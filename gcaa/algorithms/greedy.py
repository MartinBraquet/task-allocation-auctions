from dataclasses import dataclass, field

import numpy as np

from gcaa.core.utility import CalcTaskUtility, CalcUtility
from gcaa.tools.basic import PrettyDict
from gcaa.tools.winners import winner_vector_to_matrix


def GCAASolution(agents_state, G, tasks_state, map_width):
    """
    Python translation of the MATLAB GCAASolution function.

    Inputs:
        Agents      : object with attributes N, Pos, v_a, Lt, previous_task, previous_winnerBids, kdrag, rin_task, vin_task
        G           : connectivity matrix (na x na) boolean
        TasksCells  : object with attributes N, Pos, tf, r_bar, Speed, task_type, radius, tloiter, prob_a_t, lambda

    Returns:
        S_GCAA     : scalar total utility
        p          : list of lists: path per agent (each list contains 0-based task indices)
        S_GCAA_ALL : numpy array shape (nt,) task utilities
        rt         : numpy array shape (nt,) task expected reward
        Agents     : Agents object (possibly updated fields: previous_task, previous_winnerBids, rin_task, vin_task)
    """

    na = int(agents_state.N)
    pos_a = np.asarray(agents_state.Pos)

    nt = int(tasks_state.N)
    pos_t = np.asarray(tasks_state.Pos)

    # ---------------------------------------------------------------------%
    # Initialize global / helper params
    # ---------------------------------------------------------------------%
    # GCAA parameter initialization (external)
    GCAA_Params = GCAA_Init(0, 0, tasks_state.prob_a_t, tasks_state.lambda_)

    # ---------------------------------------------------------------------%
    # Define agent and task templates (use dicts as lightweight structs)
    # ---------------------------------------------------------------------%
    # agent default
    agent_default = PrettyDict(**{
        "id": 0, "type": 0, "avail": 0, "clr": None,
        "x": 0.0, "y": 0.0, "z": 0.0, "nom_vel": 0.0,
        "fuel": 0.0, "Lt": 0, "v_a": np.zeros(2),
        "rin_task": None, "vin_task": None,
        "previous_task": None, "previous_winnerBids": None,
        "kdrag": 0.0
    })

    # agent quad specialization
    agent_quad = agent_default.copy()
    agent_quad["type"] = GCAA_Params.AGENT_TYPES.QUAD
    agent_quad["nom_vel"] = 0.0
    agent_quad["fuel"] = 1.0

    # task default
    task_default = PrettyDict(**{
        "id": 0, "type": 0, "value": 0.0, "start": 0.0, "end": 0.0,
        "duration": 0.0, "tf": 0.0, "x": 0.0, "y": 0.0, "z": 0.0,
        "Speed": 0.0, "radius": 0.0, "tloiter": 0.0
    })

    # task track specialization
    task_track = task_default.copy()
    task_track["type"] = GCAA_Params.TASK_TYPES.TRACK
    task_track["value"] = 0.0
    task_track["duration"] = 0.0

    # ---------------------------------------------------------------------%
    # Create agents list and initialize from Agents object
    # ---------------------------------------------------------------------%
    agents = [None] * na
    for n in range(na):
        ag = agent_quad.copy()
        ag["id"] = n  # Python 0-based id
        ag["x"] = float(pos_a[n, 0])
        ag["y"] = float(pos_a[n, 1])
        ag["z"] = 0.0
        ag["v_a"] = np.asarray(agents_state.v_a[n, :]).copy()
        ag["Lt"] = int(agents_state.Lt[n])
        ag["rin_task"] = [] if getattr(agents_state, "rin_task",
                                       None) is None else list(
            agents_state.rin_task[n])
        ag["vin_task"] = [] if getattr(agents_state, "vin_task",
                                       None) is None else list(
            agents_state.vin_task[n])
        ag["previous_task"] = int(agents_state.previous_task[n]) if getattr(
            agents_state, "previous_task", None) is not None else -1
        ag["previous_winnerBids"] = float(
            agents_state.previous_winnerBids[n]) if getattr(agents_state,
                                                            "previous_winnerBids",
                                                            None) is not None else 0.0
        ag["kdrag"] = float(agents_state.kdrag)
        agents[n] = ag

    # ---------------------------------------------------------------------%
    # Create tasks list and initialize from TasksCells
    # ---------------------------------------------------------------------%
    tasks = [None] * nt
    for m in range(nt):
        tsk = task_track.copy()
        tsk["id"] = m  # python 0-based
        tsk["start"] = 0.0
        tsk["end"] = 1e20
        tsk["x"] = float(pos_t[m, 0])
        tsk["y"] = float(pos_t[m, 1])
        tsk["z"] = 0.0
        tsk["tf"] = float(tasks_state.tf[m])
        tsk["value"] = float(tasks_state.r_bar[m])
        tsk["Speed"] = tasks_state.Speed[m]
        tsk["type"] = int(tasks_state.task_type[m])
        tsk["radius"] = float(tasks_state.radius[m])
        tsk["tloiter"] = float(tasks_state.tloiter[m])
        tasks[m] = tsk

    # ---------------------------------------------------------------------%
    # Run GCAA (external).
    # ---------------------------------------------------------------------%
    GCAA_Assignments, S_GCAA_agents, S_GCAA_ALL_agents = GCAA_Main(
        agents, tasks, G, tasks_state.prob_a_t, tasks_state.lambda_,
        map_width
    )

    # Prepare p (paths) as list of lists
    p = [None] * na
    for i in range(na):
        # Expect GCAA_Assignments[i].path to be a list/array of task indices.
        path = list(GCAA_Assignments[i].path)
        # Trim at first -1 if present (MATLAB used -1 as terminator)
        if -1 in path:
            idx = path.index(-1)
            path = path[:idx]
        p[i] = path

    # Build winners vector: for each agent, first assigned task (or 0/None)
    winners = - np.ones(na, dtype=int)
    for i in range(na):
        task_idx = p[i][0] if p[i] else -1
        winners[i] = int(task_idx)

    # Convert winners vector to winners_matrix
    winners_matrix = winner_vector_to_matrix(na, nt, winners)

    # ---------------------------------------------------------------------%
    # Compute task utilities S_GCAA_ALL and rt
    # ---------------------------------------------------------------------%
    S_GCAA_ALL = np.zeros(nt)
    rt = np.zeros(nt)
    for j in range(nt):
        # CalcTaskUtility expects j as 0-based index in the Python translation earlier
        S_GCAA_ALL[j] = CalcTaskUtility(
            np.asarray(agents_state.Pos),
            np.asarray(agents_state.v_a),
            np.asarray(tasks_state.Pos[j, :]),
            np.asarray(tasks_state.Speed[j]),
            float(tasks_state.tf[j]),
            float(tasks_state.r_bar[j]),
            j,  # 0-based index
            np.asarray(tasks_state.prob_a_t),
            winners_matrix,
            float(tasks_state.lambda_),
            float(agents_state.kdrag)
        )
        # expected reward rt (match MATLAB formula)
        rt[j] = float(tasks_state.r_bar[j]) * (1.0 - np.prod(
            1.0 - winners_matrix[:, j] * np.asarray(tasks_state.prob_a_t)[:, j]
        ))

    S_GCAA = float(np.sum(S_GCAA_ALL))

    # ---------------------------------------------------------------------%
    # Fix the tasks if the completion is close (update Agents.previous_task / previous_winnerBids)
    # ---------------------------------------------------------------------%
    for i in range(na):
        task_idx_list = p[i]
        if not task_idx_list:
            agents_state.previous_task[i] = -1
            agents_state.previous_winnerBids[i] = 0.0
        else:
            # task_idx_list may contain multiple tasks; original MATLAB used `tasks(task_idx).tloiter`
            # Here use first assigned task
            task_idx = int(task_idx_list[0])
            tloiter = tasks[task_idx]["tloiter"]
            tf_task = tasks[task_idx]["tf"]
            # if close to completion, revert to previous_task
            if tloiter > 0 and (tf_task - tloiter) / tloiter < 1:
                # revert
                p[i] = (
                    [int(agents_state.previous_task[i]) - 1]
                    if agents_state.previous_task[i] >= 0 else []
                )
                agents[i]["rin_task"] = []
            else:
                # update Agents previous info
                agents_state.previous_task[i] = int(task_idx)
                agents_state.previous_winnerBids[i] = float(
                    S_GCAA_ALL_agents[i])

    # ---------------------------------------------------------------------%
    # Copy internal agents' rin_task/vin_task back into Agents object if present
    # ---------------------------------------------------------------------%
    for i in range(na):
        # if agents[i]['rin_task'] is truthy and has transpose-compatible shape
        if agents[i].get("rin_task") is not None:
            # agents(i).rin_task' in MATLAB -> transpose; we stored row-like arrays
            agents_state.rin_task[i, :] = np.asarray(
                agents[i]["rin_task"]).reshape(-1)
            agents_state.vin_task[i, :] = np.asarray(
                agents[i]["vin_task"]).reshape(-1)

    return S_GCAA, p, S_GCAA_ALL, rt, agents_state


@dataclass
class AgentTypes:
    QUAD: int = 1
    CAR: int = 2


@dataclass
class TaskTypes:
    TRACK: int = 1
    RESCUE: int = 2


@dataclass
class GCAAParams:
    N: int
    M: int
    prob_a_t: np.ndarray
    lambda_: float
    MAX_STEPS: int = 10_000_000

    AGENT_TYPES: AgentTypes = field(default_factory=AgentTypes)
    TASK_TYPES: TaskTypes = field(default_factory=TaskTypes)

    # compatibility matrix
    CM: np.ndarray = field(init=False)

    def __post_init__(self):
        # number of agent types × number of task types
        n_agent_types = len(vars(self.AGENT_TYPES))
        n_task_types = len(vars(self.TASK_TYPES))

        self.CM = np.zeros((n_agent_types, n_task_types), dtype=int)

        # QUAD → TRACK
        self.CM[self.AGENT_TYPES.QUAD - 1, self.TASK_TYPES.TRACK - 1] = 1

        # CAR → RESCUE
        self.CM[self.AGENT_TYPES.CAR - 1, self.TASK_TYPES.RESCUE - 1] = 1

    def __getitem__(self, key):
        """Enable dictionary-style access to fields."""
        return getattr(self, key)


def GCAA_Init(N, M, prob_a_t, lambda_):
    """
    Python translation of MATLAB GCAA_Init
    """
    return GCAAParams(
        N=N,
        M=M,
        prob_a_t=np.asarray(prob_a_t),
        lambda_=lambda_
    )


def GCAA_Main(agents, tasks, Graph, prob_a_t, lambda_, map_width):
    # --------------------------------------
    # Initialize GCAA parameters
    # --------------------------------------
    GCAA_Params = GCAA_Init(
        len(agents),
        len(tasks),
        prob_a_t,
        lambda_
    )

    # --------------------------------------
    # Initialize GCAA_Data
    # --------------------------------------
    GCAA_Data = []
    for i in range(GCAA_Params['N']):
        a = agents[i]
        data = PrettyDict(**{
            'agentID': a['id'],
            'agentIndex': i,
            'path': -np.ones(a['Lt'], dtype=int),
            'times': -np.ones(a['Lt'], dtype=float),
            'winners': -np.ones(GCAA_Params['N'], dtype=int),
            'winnerBids': np.zeros(GCAA_Params['N'], dtype=float),
            'fixedAgents': np.zeros(GCAA_Params['N'], dtype=int),
            'Lt': a['Lt'],
        })
        GCAA_Data.append(data)

    # --------------------------------------
    # Fix tasks if completion is close
    # --------------------------------------
    for i in range(GCAA_Params['N']):
        task_idx = agents[i]['previous_task']  # 0-based; -1 means "none"
        if task_idx >= 0:

            tf = tasks[task_idx]['tf']
            tloiter = max(tasks[task_idx]['tloiter'], .1)
            dist = np.sqrt((tasks[task_idx].x - agents[i].x) ** 2 + (tasks[task_idx].y - agents[i].y) ** 2)

            if tf - tloiter < tloiter or dist < .1 * map_width:
                print(f"Fixing agent {i} to task {task_idx} since close to completion")
                GCAA_Data[i]['fixedAgents'][i] = 1
                GCAA_Data[i]['path'] = [task_idx]
                GCAA_Data[i]['winners'][i] = task_idx
                GCAA_Data[i]['winnerBids'][i] = agents[i]['previous_winnerBids']

    # --------------------------------------
    # Working variables
    # --------------------------------------
    T = 0
    t = np.zeros((GCAA_Params['N'], GCAA_Params['N']))
    lastTime = T
    doneFlag = 0

    # --------------------------------------
    # Main GCAA Loop
    # --------------------------------------
    while doneFlag == 0:

        # -------------------------------
        # 1. Communicate (Algo 2)
        # -------------------------------
        t = GCAA_Communicate_Single_Assignment(
            GCAA_Params, GCAA_Data, Graph, t, T
        )

        # -------------------------------
        # 2. Bundle building (Algos 3 & 1)
        # -------------------------------
        for i in range(GCAA_Params['N']):
            if GCAA_Data[i]['fixedAgents'][i] == 0:
                newBid = GCAA_Bundle(
                    GCAA_Params,
                    GCAA_Data[i],
                    agents[i],
                    tasks,
                    i
                )

        # Determine if all agents are fixed
        doneFlag = 1
        for i in range(GCAA_Params['N']):
            if GCAA_Data[i]['fixedAgents'][i] == 0:
                doneFlag = 0
                break

        # -------------------------------
        # 3. Convergence check
        # -------------------------------
        if T - lastTime > 2 * GCAA_Params['N']:
            print("Algorithm did not converge after 2 N steps (N being the number of agents)")
            doneFlag = 1
            for i in range(GCAA_Params['N']):
                if GCAA_Data[i]['fixedAgents'][i] == 0:
                    task_idx = agents[i]['previous_task']
                    GCAA_Data[i]['path'] = [task_idx]
                    GCAA_Data[i]['winners'][i] = task_idx
                    GCAA_Data[i]['winnerBids'][i] = agents[i]['previous_winnerBids']
        else:
            T += 1

    # --------------------------------------
    # Compute final scores
    # --------------------------------------
    All_scores = np.zeros(GCAA_Params['N'])
    Total_Score = 0.0

    for i in range(GCAA_Params['N']):
        All_scores[i] = GCAA_Data[i]['winnerBids'][i]
        Total_Score += All_scores[i]

    # print('GCAA_Data[i].path:', [GCAA_Data[i].path for i in range(GCAA_Params['N'])])

    return GCAA_Data, Total_Score, All_scores


def GCAA_Communicate_Single_Assignment(GCAA_Params, GCAA_Data, Graph, old_t, T):
    N = GCAA_Params['N']

    # --------------------------------------
    # Copy data into old_z, old_y, old_f
    # --------------------------------------
    old_z = np.zeros((N, N), dtype=int)
    old_y = np.zeros((N, N), dtype=float)
    old_f = np.zeros((N, N), dtype=int)

    for n in range(N):
        old_z[n, :] = GCAA_Data[n]['winners']
        old_y[n, :] = GCAA_Data[n]['winnerBids']
        old_f[n, :] = GCAA_Data[n]['fixedAgents']

    # initialize working copies
    z = old_z.copy()
    y = old_y.copy()
    f = old_f.copy()
    t = old_t.copy()

    # --------------------------------------
    # Communication loop
    # --------------------------------------
    for i in range(N):
        for k in range(N):
            if Graph[k, i] == 1:

                # overwrite row i, column k
                z[i, k] = old_z[k, k]
                y[i, k] = old_y[k, k]
                f[i, k] = old_f[k, k]

                # update timestamps based on latest communication
                for n in range(N):
                    if n != i and t[i, n] < old_t[k, n]:
                        t[i, n] = old_t[k, n]

                t[i, k] = T

    # --------------------------------------
    # Copy back into GCAA_Data
    # --------------------------------------
    for n in range(N):
        GCAA_Data[n]['winners'] = z[n, :].copy()
        GCAA_Data[n]['winnerBids'] = y[n, :].copy()
        GCAA_Data[n]['fixedAgents'] = f[n, :].copy()
        t[n, n] = T

    return t


def GCAA_Bundle(GCAA_Params, GCAA_Data, agent, tasks, agent_idx):
    """
    Direct translation of MATLAB GCAA_Bundle.m
    """

    # Algo 3: Update bundles after messaging (remove tasks that are outbid)
    GCAA_BundleRemoveSingleAssignment(GCAA_Params, GCAA_Data, agent_idx)

    # Algo 1: Bid on new tasks and add them to the bundle
    GCAA_BundleAdd(GCAA_Params, GCAA_Data, agent, tasks, agent_idx)

    newBid = 0.0

    return newBid


def GCAA_BundleRemoveSingleAssignment(GCAA_Params, GCAA_Data, agent_idx):
    """
    Direct translation of MATLAB GCAA_BundleRemoveSingleAssignment.m
    All arrays are assumed to be 0-based numpy arrays.
    """

    # MATLAB: if sum(GCAA_Data.winnerBids) == 0; return
    if np.sum(GCAA_Data["winnerBids"]) == 0:
        return

    # Equivalent of:
    # if GCAA_Data.winners(agent_idx) > 0
    if GCAA_Data["winners"][agent_idx] >= 0:

        # All_winners = (winners == winners(agent_idx)) .* (fixedAgents == 0)
        All_winners = (
            (GCAA_Data["winners"] == GCAA_Data["winners"][agent_idx])
            & (GCAA_Data["fixedAgents"] == 0)
        )

        if np.sum(All_winners) > 0:
            # All_winnerBids = winnerBids .* All_winners
            All_winnerBids = GCAA_Data["winnerBids"] * All_winners

            # MATLAB: All_winnerBids(All_winnerBids == 0) = -1e16
            All_winnerBids = All_winnerBids.copy()
            All_winnerBids[All_winnerBids <= 0] = -1e16

            # maxBid, idxMaxBid = max(...)
            idxMaxBid = np.argmax(All_winnerBids)
            maxBid = All_winnerBids[idxMaxBid]

            # All_losers = All_winners; All_losers(idxMaxBid) = 0
            All_losers = All_winners.copy()
            All_losers[idxMaxBid] = 0

            GCAA_Data["winners"][All_losers] = -1
            GCAA_Data["winnerBids"][All_losers] = 0.

            # GCAA_Data.fixedAgents(idxMaxBid) = 1
            GCAA_Data["fixedAgents"][idxMaxBid] = 1


def GCAA_BundleAdd(GCAA_Params, GCAA_Data, agent, tasks, agent_idx):
    """
    Select the best task for agent i (GCAA Algorithm 1)

    Parameters
    ----------
    GCAA_Params : object
        Contains N, M, prob_a_t, lambda, etc.
    GCAA_Data : object
        Data structure for this agent
    agent : object
        Agent object with fields x, y, v_a, rin_task, vin_task, kdrag
    tasks : list of objects
        Each task object has attributes: x, y, Speed, tf, tloiter, radius, type, value
    agent_idx : int
        Index of the agent (0-based)

    Returns
    -------
    GCAA_Data : object
        Updated GCAA_Data for this agent
    agent : object
        Updated agent with new rin_task and vin_task if assigned
    """

    if GCAA_Data['fixedAgents'][agent_idx] == 1:
        return

    M = len(tasks)

    # Extract task info
    task_pos = np.array([[t.x, t.y] for t in tasks])
    task_v = np.array([t.Speed for t in tasks])
    task_tf = np.array([t.tf for t in tasks])
    task_tloiter = np.array([t.tloiter for t in tasks])
    task_radius = np.array([t.radius for t in tasks])
    task_type = np.array([t.type for t in tasks])
    task_value = np.array([t.value for t in tasks])

    # Initialize
    U = -1e14
    b = None
    newRin = False

    # Build current winner matrix
    winners_matrix = np.zeros((GCAA_Params.N, GCAA_Params.M), dtype=int)
    for i in range(GCAA_Params.N):
        w = GCAA_Data['winners'][i]
        if w is not None and w >= 0:
            winners_matrix[i, w] = 1

    # Identify available tasks
    availTasks = [j for j in range(M) if not any(winners_matrix[:, j] == 1)]

    # If all tasks are assigned, pick all tasks for evaluation
    if len(availTasks) == 0:
        availTasks = list(range(M))
        U = 0

    # Evaluate utility for available tasks
    for j in availTasks:
        if task_tf[j] > task_tloiter[j]:
            b_new = j

            # Temporarily assign this agent to task j
            winners_matrix[agent_idx, :] = 0
            winners_matrix[agent_idx, j] = 1

            rin_t_new, vin_t_new, U_new = CalcUtility(
                np.array([agent.x, agent.y]),
                agent.v_a,
                task_pos,
                task_v,
                task_type,
                task_radius,
                task_tloiter,
                task_tf,
                task_value,
                b_new,
                agent_idx,
                GCAA_Params.prob_a_t,
                GCAA_Params.N,
                winners_matrix,
                GCAA_Params.lambda_,
                agent.kdrag
            )

            if U_new > U:
                U = U_new
                b = b_new
                rin_t = rin_t_new
                vin_t = vin_t_new
                newRin = True

    # Update agent and GCAA_Data
    GCAA_Data['path'] = [b]
    GCAA_Data['winnerBids'][agent_idx] = U
    if b is None:
        b = -1
    GCAA_Data['winners'][agent_idx] = b

    if newRin:
        agent.rin_task = rin_t
        agent.vin_task = vin_t
