close all;

t0 = 0;
t1 = 1;
r0 = [0; 0];
r1 = [1; 0];
v0 = [0; -1];
v1 = [1; 1];

dydt = @(t,y) [y(3:4); 4/(t1-t) * (v1 - y(3:4)) + 6/(t1-t)^2 * (r1 - (y(1:2) + v1*(t1 - t)))];

options = odeset('RelTol',1e-5,'Stats','on','OutputFcn',@odeplot);
[t,y] = ode45(dydt, [t0 t1], [r0; v0], options);

r = y(:,1:2);
v = y(:,3:4);
a = zeros(size(v));
norm_a = zeros(length(t),1);

for i = 1:length(t)
    a(i,:) = 4/(t1-t(i)) .* (v1' - v(i,:)) + 6/(t1-t(i)).^2 .* (r1' - (r(i,:) + v1'.*(t1 - t(i))));
    norm_a(i) = norm(a(i,:));
end

a(isnan(a)) = 0;
norm_a(isnan(norm_a)) = 0;

J = trapz(t,norm_a)

figure;
plot(y(:,1), y(:,2));

figure;
plot(t, norm_a);