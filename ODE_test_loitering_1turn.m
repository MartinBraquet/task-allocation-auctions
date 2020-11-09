close all;

t0 = 0;
tin = 1;
tT = 4;
tf = 10;
ra = [0; 0];
rt = [1; 0];
R = 0.2;
va = [0; 0.6];
nturns_loitering = 1;

norm_vt = nturns_loitering * 2*pi * R / tT;

time_step = tf / 1000;
t_circle = 0:time_step:(tf-tT);
t = (0:time_step:tf)';

rho = 1e16;
for theta = linspace(0, 2*pi, 10)
    rin_new = rt + R * [cos(theta); sin(theta)];
    for i = [-1 1]
        vt_new = i * [0 1; -1 0] * (rin_new - rt) * norm_vt / norm(rin_new - rt);
        [a_new, r_new, v_new, rho_new] = ComputeCommandParamsWithVelocity(ra, va, rin_new, vt_new, tf - tT, t_circle);
        if rho_new < rho
            rho = rho_new;
            rin = rin_new;
            vt = vt_new;
            a_to_target = a_new;
            r_to_target = r_new;
            v_to_target = v_new;
        end
    end
end

norm_a = norm_vt^2 / R;

r = zeros(length(t),2);
r(1:length(t_circle),:) = r_to_target;
v = zeros(length(t),2);
v(1:length(t_circle),:) = v_to_target;
a = zeros(length(t),2);
a(1:length(t_circle),:) = a_to_target;

for i = length(t_circle)+1:length(t)
    a(i,:) = (rt' - r(i-1,:)) * norm_a / norm(rt' - r(i-1,:));
    v(i,:) = v(i-1,:) + time_step * a(i,:);
    r(i,:) = r(i-1,:) + time_step * v(i,:);
end

J = rho + 1/2 * (norm_a)^2 * tT;

figure; hold on;
plot(r(:,1), r(:,2), 'LineWidth', 2);

n = 20;
theta = linspace(0, 2*pi, n)';
pos = repmat(rt', n, 1) + R * [cos(theta) sin(theta)];
plot(pos(:,1), pos(:,2), 'r--', 'LineWidth', 2);
xlim([-0.5 1.75]);
ylim([-1 1]);


% figure;
% plot(t, norm_a);