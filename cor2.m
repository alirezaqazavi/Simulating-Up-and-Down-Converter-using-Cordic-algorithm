function [i,q]=cor2(InputSignal_r,InputSignal_i,Up_Down,f_IF,n,Fs,Num_of_Iter)
%%  [i,q]=cor2(Up_Down,f_IF,n) converts InputSignal up or down and plot related graphs
% n is length of InputSignal, if Up_Down == 0 we have upconvertion and if
% Up_Down == 1 we have downconvertion, f_IF is IF frequency,Fs is sampeling
% frequency , with Num_of_Iter iteration for cordic alg
% author:Alireza Qazavi, IUT
% Email: alirezaqazavi@gmail.com
%%
i = zeros(1,n);
q = zeros(1,n);

% Initialization of tables of constants used by CORDIC
% need a table of arctangents of negative powers of two, in radians:
% angles = atan(2.^-(0:27));
angles =  [  ...
    0.78539816339745   0.46364760900081   0.24497866312686   0.12435499454676 ...
    0.06241880999596   0.03123983343027   0.01562372862048   0.00781234106010 ...
    0.00390623013197   0.00195312251648   0.00097656218956   0.00048828121119 ...
    0.00024414062015   0.00012207031189   0.00006103515617   0.00003051757812 ...
    0.00001525878906   0.00000762939453   0.00000381469727   0.00000190734863 ...
    0.00000095367432   0.00000047683716   0.00000023841858   0.00000011920929 ...
    0.00000005960464   0.00000002980232   0.00000001490116   0.00000000745058 ];
arctan = rad2deg(angles);
% and a table of products of reciprocal lengths of vectors [1, 2^-2j]:
% Kvalues = cumprod(1./abs(1 + 1j*2.^(-(0:23))))
Kvalues = [ ...
    0.70710678118655   0.63245553203368   0.61357199107790   0.60883391251775 ...
    0.60764825625617   0.60735177014130   0.60727764409353   0.60725911229889 ...
    0.60725447933256   0.60725332108988   0.60725303152913   0.60725295913894 ...
    0.60725294104140   0.60725293651701   0.60725293538591   0.60725293510314 ...
    0.60725293503245   0.60725293501477   0.60725293501035   0.60725293500925 ...
    0.60725293500897   0.60725293500890   0.60725293500889   0.60725293500888 ];

% step = 0; %input('Enter step between 0 to 7: ');
% delta = arctan(step+1); % angular seperation between 2 pts
% f_IF = 50000;
Ts = 1/Fs;
if Up_Down == 0 %Up Convertion
    delta = rad2deg(2*pi*f_IF*Ts);
elseif Up_Down == 1 %Down Convertion
    delta = -rad2deg(2*pi*f_IF*Ts);
end

an = Kvalues(Num_of_Iter+1); %starting gain value
x = an*InputSignal_r(1);
y = an*InputSignal_i(1);
z = 0;

theta = 0; % 0 on reset
z = theta;

for j = 1:n
    if (z > 90) && (z < 180) %quarter2
        z = z - 90;
        x = -an*InputSignal_i(j);
        y = an*InputSignal_r(j);
    elseif (z >= 180) && (z < 270) %quarter3
        z = z - 180;
        x = -an*InputSignal_r(j);
        y = -an*InputSignal_i(j);
    elseif z >= 270 %quarter4
        z = z - 360;
%         y = -an*InputSignal_i(j);
    end;
    for k = 0:Num_of_Iter % number of iterations
        if z >= 0
            d = 1;
        else
            d = -1;
        end;
        xn = x - y*d*2.^(-1*k);
        yn = y + x*d*2.^(-1*k);
        zn = z - d*arctan(k+1);
        x = xn;
        y = yn;
        z = zn;
    end;
    i(j) = xn; % saving to vector - inphase
    q(j) = yn; % saving to vector - quadrature
    x = an*InputSignal_r(j); %starting gain value
    y = 0;
    theta = theta + delta;
    if theta > 360
        theta = theta -360;
    end;
    z = theta;
end;

out_i = fi(i, 1, 8); % 8 bit quadrature output test vector 
out_q = fi(q, 1, 8); % 8 bit inphase output test vector 

figure
subplot(2,1,1); plot(i);title('In-Phase');xlabel('time(sec)');ylabel('i(t)');
grid on;
subplot(2,1,2); plot(q);title('Quadrature');xlabel('time(sec)');ylabel('q(t)');
grid on;

%---------FFT calculation---------------
% Fs = 200000;                    % Sampling frequency
% T = 1/Fs;                     % Sample time
% L = 1000;                     % Length of signal
% t = (0:L-1)*T;                % Time vector

end