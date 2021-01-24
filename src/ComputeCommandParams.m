function [a, b, rho] = ComputeCommandParams(pos_a_curr, v_a_curr, pos_t_curr, tf)
% 
    a =   6/tf^2 * (pos_t_curr - pos_a_curr) - 4/tf   * v_a_curr;
    b = -12/tf^3 * (pos_t_curr - pos_a_curr) + 6/tf^2 * v_a_curr;
    rho = 1/2 * (tf * norm(a)^2 + tf^2 * a*b' + (1/3) * tf^3 * norm(b)^2);

end

