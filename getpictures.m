function p = getpictures()

RGB = imread('D:\Материалы к магистерской\Новая тема магистерской\текст и фото магистерской\1.4.jpg'); % считываем исходное изображение в RGB
%RGB = imread(pic);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Сегментация цветных изображений на основе кластеризации по методу k-средних
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Преобразуем изображение из цветовой системы RGB в цветовую систему L*a*b*
cform = makecform('srgb2lab'); 
lab_RGB = applycform(RGB, cform);

% Классифицируем цвета в пространстве 'a*b*' с использованием кластеризации 
ab = double(lab_RGB(:, :, 2:3));
nrows = size(ab, 1);
ncols = size(ab, 2);
ab = reshape(ab, nrows*ncols, 2);
nColors = 3; % разбиваем на 3 класса цветов
[cluster_idx, cluster_center] = kmeans(ab, nColors, 'distance', 'sqEuclidean', ...
                                      'Replicates',3); % используем кластеризацию методом k-средних для разделения объектов на 3 кластера, для этого используем евклидовую метрику.

% Присваиваем метки каждому пикселю изображения на основе метода k-средних
pixel_labels = reshape(cluster_idx, nrows,ncols);
%figure(1), subplot(1,2,1), imshow(RGB); title('исходное'); % выводим на экран исходное изображение, и разбитое на 3 кластера 

% Создаём сегментированное изображение на основе цветного
segmented_images = cell(1, 3);
rgb_label = repmat(pixel_labels, [1 1 3]); % используя параметр pixel_labels, можно разделить объекты на изображении по цветам
for k = 1 : nColors
  color = RGB; % считываем цвет пикселя с исходного ихображения
  color(rgb_label ~= k) = 0; % если цвет пикселя не совпадает с цветом метки, то делаем его чёрным
  segmented_images{k} = color; % если совпадает, то оставляем исходный цвет зоны
end

% выберем нужную нам зону меланомы
mean_cluster_val = zeros(3, 1);
for k = 1:nColors
  mean_cluster_val(k) = mean(cluster_center(k)); % найдем кластеры, которые содержат тёмные объекты
end
[mean_cluster_val,idx] = sort(mean_cluster_val);

% параметр cluster_center содержит среднее значение 'a*' и 'b*' для каждого кластера. Тёмный кластер имеет 3ее наибольшее значение cluster_center.
brown_cluster_num = idx(3);

[height, width, dim] = size(segmented_images{brown_cluster_num}); % определяем размеры изображения и измерение пикселя (3, тк RGB) 

% преобразуем сегментированное цветное изображение сначала в изобр. в оттенках серого, а потом в бинарное
GR = rgb2gray(segmented_images{brown_cluster_num});
BW = imbinarize(GR);

%subplot(1,2,2), imshow(BW), title('бинарное');

octagon = strel('octagon',6)
bw_octagon = imerode(BW, octagon); % проводит операцию утончения бинарных изображений, т.е. позволит убрать лишние элементы и шум
se = strel('octagon',90);
closeBW = imclose(bw_octagon, se); % выполняет морфологическое закрытие бинарного изображения, т.е. заполняет пробелы в контуре нашей меланомы

BWdfill = imfill(closeBW, 'holes'); % заполним оставшиеся дыры, получившиеся в ходе выполнения морфологисеких операций

%figure(3)
%montage({BW, bw_octagon, closeBW }) % отображаем в одном окне бинарное, очищенное от шума и итоговое изображение

figure();
subplot(1,3,1), imshow(RGB), title('Исходное');
subplot(1,3,2), imshow(BW), title('Бинарное');
subplot(1,3,3), imshow(BWdfill), title('Итоговое');

p = BWdfill(:,:,1);  % копируем в матрицу р бинарные значения из матрицы бинарного изображения BW
p = double(p);  % преобразуем их из типа logic в doublе для дальнейшей работы с ними
for i = height+1:width
   for j = 1:width
       p(i,j) = 0;  % цикл для создания квадратной матрицы (путём добавления 1(те белого цвета) в конец матрицы), тк матрица должна быть квадратной
   end
end