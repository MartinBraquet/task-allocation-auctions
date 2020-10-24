function [u, r, v, rho] = ComputeCommandParamsWithVelocity(pos_a_curr, v_a_curr, pos_t_curr, v_t, tf, t)

    t0 = 0;
    t1 = tf;
    r0 = pos_a_curr;
    r1 = pos_t_curr;
    v0 = v_a_curr;
    v1 = v_t;
    
    if isempty(t)
        t = [t0 t1];
    end

    dydt = @(t,y) [y(3:4); 4/(t1-t) * (v1 - y(3:4)) + 6/(t1-t)^2 * (r1 - (y(1:2) + v1*(t1 - t)))];

    %options = odeset('RelTol',1e-5);
    [t,y] = ode23s(dydt, t, [r0; v0]); %, options);

    r = y(:,1:2);
    v = y(:,3:4);
    a = zeros(size(v));
    norm2_a = zeros(length(t),1);

    for i = 1:length(t)
        a(i,:) = 4/(t1-t(i)) .* (v1' - v(i,:)) + 6/(t1-t(i)).^2 .* (r1' - (r(i,:) + v1'.*(t1 - t(i))));
        norm2_a(i) = norm(a(i,:)).^2;
    end

    a(isnan(a) | isinf(a)) = 0;
    norm2_a(isnan(norm2_a) | isinf(norm2_a)) = 0;

    rho = 1/2 * trapz(t,norm2_a);
    u = a;
    
end