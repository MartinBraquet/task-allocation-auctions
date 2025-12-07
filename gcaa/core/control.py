import numpy as np
from scipy.integrate import solve_ivp

def ComputeCommandParamsWithVelocity(pos_a_curr, v_a_curr, pos_t_curr, v_t, tf, t, kdrag):
    """
    Direct translation of the MATLAB function:
    [u, r, v, t, rho] = ComputeCommandParamsWithVelocity(...)
    """

    t0 = 0
    t1 = tf

    r0 = pos_a_curr.reshape(2)
    r1 = pos_t_curr.reshape(2)

    v0 = v_a_curr.reshape(2)
    v1 = v_t.reshape(2)

    # MATLAB: if isempty(t), default to [t0 t1]
    if t is None or len(t) == 0:
        t = np.linspace(t0, t1, num=101)
    else:
        t = np.array(t, dtype=float)

    # ODE RHS: dy/dt = [v ; a(t, r, v)]
    def dydt(t_local, y):
        r = y[0:2]
        v = y[2:4]
        dt = max(t1 - t_local, 1e-4)  # prevent division by zero

        # MATLAB expression:
        # a = 4/(t1-t)*(v1 - v) + 6/(t1-t)^2 * (r1 - (r + v1*(t1 - t)))
        a = (4.0 / dt) * (v1 - v) + (6.0 / dt**2) * (r1 - (r + v1 * dt))
        # print(t_local, y, a)

        return np.hstack([v, a])

    # Solve ODE (MATLAB ode45 equivalent)
    sol = solve_ivp(
        fun=dydt,
        t_span=(t[0], t[-1]),
        y0=np.hstack([r0, v0]),
        t_eval=t,
        method='RK45',        # closest to ode45
        rtol=1e-6, atol=1e-9   # MATLAB defaults are modest; these are similar
    )

    # Extract output trajectories
    y = sol.y.T
    r = y[:, 0:2]
    v = y[:, 2:4]

    # Compute acceleration explicitly at all times
    a = np.zeros_like(v)
    norm2_a = np.zeros(len(t))

    for i in range(len(y)):
        a[i, :] = dydt(t[i], y[i, :])[2:4]
        norm2_a[i] = np.linalg.norm(a[i, :])**2

    # Clean NaN & Inf exactly like MATLAB code
    a[~np.isfinite(a)] = 0.0
    norm2_a[~np.isfinite(norm2_a)] = 0.0

    # MATLAB: rho = 1/2 * trapz(t, norm2_a)
    rho = 0.5 * np.trapz(norm2_a, t)

    u = a
    return u, r, v, t, rho


def OptimalControlSolution(pos_a, v_a, pos_t, v_t, radius_t, p_GCAA, agents, tf_t, tloiter_t, time_step, n_rounds, na, kdrag):
    X = np.zeros((4, na, n_rounds+1))
    J = np.zeros((1, na))
    J_to_completion_target = np.zeros((1, na))
    completed_tasks = []

    A = np.block([[np.zeros((2,2)), np.eye(2)],
                  [np.zeros((2,2)), np.zeros((2,2))]])
    B = np.block([[np.zeros((2,2))],
                  [np.eye(2)]])

    for i in range(na):
        X[:, i, 0] = np.hstack([pos_a[i, :], v_a[i, :]])

        # No tasks assigned
        if not p_GCAA[i] or (len(p_GCAA[i]) == 1 and p_GCAA[i][0] == -1):
            p_GCAA[i] = []
            for k in range(n_rounds):
                if k == 0:
                    u = -kdrag * X[2:4, i, k]
                    X[:, i, k+1] = X[:, i, k] + time_step * (A @ X[:, i, k] + (B @ u).flatten())
                else:
                    X[:, i, k+1] = X[:, i, k]

        # Iterate through assigned tasks
        for j, ind_task in enumerate(p_GCAA[i]):
            k = 0
            tf = tf_t[ind_task]
            if j > 0:
                tf -= tf_t[p_GCAA[i][j-1]]

            pos_t_curr = pos_t[ind_task, :].reshape(-1, 1)
            v_t_curr = v_t[ind_task, :].reshape(-1, 1)
            pos_a_curr = X[0:2, i, k].reshape(-1, 1)
            v_a_curr = X[2:4, i, k].reshape(-1, 1)

            J_to_completion_target_curr = 0
            if tf > tloiter_t[ind_task] + time_step:
                t_to_target = np.arange(0, tf - tloiter_t[ind_task] + time_step, time_step)
                uparams, rparams, vparams, tparams, J_to_completion_target_curr = ComputeCommandParamsWithVelocity(
                    pos_a_curr, v_a_curr, agents.rin_task[i, :].reshape(-1, 1), agents.vin_task[i, :].reshape(-1, 1),
                    tf - tloiter_t[ind_task], t_to_target, agents.kdrag
                )

            J_to_completion_target[0, i] = J_to_completion_target_curr

            # Circular loitering parameters
            R = radius_t[ind_task]
            norm_vt = 2*np.pi*R / tloiter_t[ind_task] if tloiter_t[ind_task] > 0 else 0
            norm_a = norm_vt**2 / R if R > 0 else 0

            if tloiter_t[ind_task] > 0 and tf > 0:
                J_to_completion_target[0, i] += 0.5 * norm_a**2 * min(tloiter_t[ind_task], tf)

            # print(tf, tloiter_t[ind_task], time_step)
            t = 0
            while t + time_step <= tf:
                u = np.zeros((2,1))
                if tf > tloiter_t[ind_task] + time_step:
                    if k + 1 < len(t_to_target):
                        u = uparams[k, :].reshape(-1,1)
                        X[:, i, k+1] = X[:, i, k] + time_step * (A @ X[:, i, k] + (B @ u).flatten())
                    else:
                        X[:, i, k+1] = X[:, i, k]
                else:
                    r_target_circle = pos_t_curr - X[0:2, i, k].reshape(-1,1)
                    d = np.linalg.norm(r_target_circle)
                    alpha = 0
                    u = (1 + alpha) * norm_a * r_target_circle / d if d > 0 else np.zeros_like(r_target_circle)
                    X[:, i, k+1] = X[:, i, k] + time_step * (A @ X[:, i, k] + (B @ u).flatten())

                if k == 0:
                    J[0, i] = 0.5 * np.linalg.norm(u)**2 * time_step

                t += time_step
                k += 1

            # If agent reached the target
            if k == 1 and not any([task in completed_tasks for task in p_GCAA[i]]):
                completed_tasks.extend(p_GCAA[i])

            for k2 in range(k+1, n_rounds+1):
                X[:, i, k2] = X[:, i, k]

    return X, completed_tasks, J, J_to_completion_target

