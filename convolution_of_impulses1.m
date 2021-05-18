clc; 
close all; 
clear;

% ========== инициируем переменные:
fs = 200;
t = linspace(-1,1,fs);

convolution      = zeros(1,length(t)); % матрица свёртки, для начала заполняем нулями

set(gcf,'Color',[1 1 1]);
ax = [-1 1 -0.2 1.1];    

% ========== рисуем два одинаковых сигнала (y1 и y1):
disp('y1: одиночный прямоугольный сигнал шириной 1.0')
y1 = rectpuls(t,1);

%%%%%%%%%%%%%%%%%%%%%%%%
% создание анимации нескольких графиков в разных координатных осях

fig = figure();
% создание первого пустого кадра
set(fig,'Position',[350,200,700,300]);
frame = getframe(fig);
[im,map] = rgb2ind(frame.cdata,4);
imwrite(im,map,'convolution_rectangle_signals.gif','DelayTime',0,'Loopcount',0);
%%%%%%%%%%%%%%%%%%%%%%%%

subplot(3,2,1);plot(t,y1,'Color','blue','LineWidth',2),axis(ax); 
grid on;
xlabel('t')
ylabel('y1')

subplot(3,2,2);plot(t,y1,'Color','red','LineWidth',2),axis(ax); 
grid on;
xlabel('t')
ylabel('y1')

disp('Press Enter to continue ....'); % для продолжения наживаем Enter
pause;


% ========== свёртка сигналов y1 и y1:
sprintf('\n\n Свёртка двух сигналов y1 и y1:');

iter = length(t);
for i = 1:iter 
    moveStep = (2*i-fs)/fs; % шаг сдвига
    y2_shifted = rectpuls(-(t-moveStep),1); % сдвигание второго сигнала относительно первого
    convolution(i) = trapz(t, y1.*y2_shifted); % построение свёртки двух сигналов
    
    subplot(3,2,3:4)
    hold off;
    plot(t,y1,'Color','blue','LineWidth',2),axis(ax);
    hold on; 
    plot(t,y2_shifted,'Color','red' ,'LineWidth',2),axis(ax);
    grid on;
    xlabel('t');
   
    subplot(3,2,5:6)
    hold off
    plot(t(1:i),convolution(1:i),'Color','black','LineWidth',2); axis([-1 1 -0.2 1]);
    grid on;
    xlabel('t')
    ylabel('Свёртка(y1, y1)(t) ')
    
    pause(0.01)
    
    % записываем покадровую анимацию
    frame = getframe(fig);
    [im,map] = rgb2ind(frame.cdata,4);
    imwrite(im,map,'convolution_rectangle_signals.gif','DelayTime',0.1,'WriteMode','Append');
end

