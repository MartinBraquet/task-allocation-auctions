close all;

t0 = 0;
tin = 1;
tT = 4;
ra = [0; 0];
rt = [1; 0];
R = 0.2;
va = [0; -1];
rout = rt - [0; R];
nturns_loitering = 1;

[xa, ya] = deal(ra(1),ra(2));
[xt, yt] = deal(rt(1),rt(2));
syms x y
eqns = [(x - xa)^2 + (y - ya)^2 == norm(ra-rt)^2 - R^2, (x - xt)^2 + (y - yt)^2 == R^2];
[solx, soly] = solve(eqns,[x y]);

rin1 = [double(solx(1)); double(soly(1))];
rin2 = [double(solx(2)); double(soly(2))];

rot_direction = cross([rin1-ra; 0], [rin1-rt; 0]);

if rot_direction(3) > 0 % For clockwise
    rin = rin1;
else
    rin = rin2;
end

theta = atan2(rin(2)-rt(2),rin(1)-rt(1)) - atan2(rout(2)-rt(2),rout(1)-rt(1)); % For clockwise
norm_vt = (theta + nturns_loitering * 2*pi) / tT;
vt = (rin - ra) * norm_vt / norm(rin - ra);


dydt = @(t,y) [y(3:4); 4/(tin-t) * (vt - y(3:4)) + 6/(tin-t)^2 * (rin - (y(1:2) + vt*(tin - t)))];

options = odeset('RelTol',1e-5,'Stats','on','OutputFcn',@odeplot);
[t,y] = ode45(dydt, [t0 tin], [ra; va], options);

r = y(:,1:2);
v = y(:,3:4);
a = zeros(size(v));
norm_a = zeros(length(t),1);

for i = 1:length(t)
    a(i,:) = 4/(tin-t(i)) .* (vt' - v(i,:)) + 6/(tin-t(i)).^2 .* (rt' - (r(i,:) + vt'.*(tin - t(i))));
    norm_a(i) = norm(a(i,:));
end

a(isnan(a)) = 0;
norm_a(isnan(norm_a)) = 0;

J = trapz(t,norm_a)

figure; hold on;
plot(y(:,1), y(:,2));

n = 20;
theta = linspace(0, 2*pi, n)';
pos = repmat(rt', n, 1) + R * [cos(theta) sin(theta)];
plot(pos(:,1), pos(:,2), '--', 'LineWidth', 1);
xlim([0 1.5]);
ylim([-0.75 0.75]);


figure;
plot(t, norm_a);