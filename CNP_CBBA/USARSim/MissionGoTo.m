function MissionGoTo(UAV, P1, P2, P3)
    A = [P1(2), P1(1), P1(3)];
    B = [P2(2), P2(1), P2(3)];
    C = [P3(2), P3(1), P3(3)];
    T = P3(4);
    a = A-B; % вектора BA и BC, точка B общая для векторов 
    b = C-B;
       
    sa = a(1)*b(2)-b(1)*a(2);
    
    Deg = acosd(dot(a,b)/(norm(a)*norm(b)));

    Deg = 180-Deg;
     
    MaxAltitudeSpeed = 1;
    MaxLinearSpeed = 1;
    MaxLateralSpeed = 1;
    MaxRotationSpeed = 45;

    %Deg = acosd(dot(AC,AB)/(norm(AC)*norm(AB)));
    
    Distance = (sqrt((C(1)-B(1))^2+(C(2)-B(2))^2+(C(3)-B(3))^2));
    Height = C(3)-B(3);

    % Определяем время и скорость поворота
    if Deg <= MaxRotationSpeed
        RotationTime = 1;
        RotationSpeed = Deg;
    else
        RotationTime = round(Deg/MaxRotationSpeed);
        RotationSpeed = Deg/RotationTime;
    end
    
    %определяем направление поворота.
    if (sa > 0)
        RotationSpeed = (-1)*RotationSpeed;
    end  
    
    % Определяем время и скорость прямолинейного движения 
    if Distance <= MaxLinearSpeed
        LinearTime = 1;
        LinearSpeed = Distance;
    else
        LinearTime = round(Distance/MaxLinearSpeed);
        LinearSpeed = Distance/LinearTime;
    end

    % Определяем время и скорость высоты
    if (Height <= MaxAltitudeSpeed) && (Height >=0)
        AltitudeTime = 1;
        AltitudeSpeed = Height;
    elseif Height < 0
        AltitudeTime = round(abs(Height)/MaxAltitudeSpeed);
        AltitudeSpeed = -Height/AltitudeTime;
    else
        AltitudeTime = round(Height/MaxAltitudeSpeed);
        AltitudeSpeed = Height/AltitudeTime;
    end

    LateralSpeed = 0.0;

    %Повернем БЛА в нужном направлении 
    UAV.aerialDrive(0,0,0,RotationSpeed,1);
    pause(RotationTime); 

    %Останавливаем движение послав команду с нулевыми скоростями
    UAV.aerialDrive(0,0,0,0,1); 
    pause(1); 

    %Движемся к нашей точке 
    UAV.aerialDrive(AltitudeSpeed,LinearSpeed,LateralSpeed,0,0);
    pause(LinearTime); 
    
    %Останавливаем движение и висим над точкой заданное время
    UAV.aerialDrive(0,0,0,0,1); 
    pause(T); 
