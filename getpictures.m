function p = getpictures()

RGB = imread('D:\��������� � ������������\����� ���� ������������\����� � ���� ������������\1.4.jpg'); % ��������� �������� ����������� � RGB
%RGB = imread(pic);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����������� ������� ����������� �� ������ ������������� �� ������ k-�������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%����������� ����������� �� �������� ������� RGB � �������� ������� L*a*b*
cform = makecform('srgb2lab'); 
lab_RGB = applycform(RGB, cform);

% �������������� ����� � ������������ 'a*b*' � �������������� ������������� 
ab = double(lab_RGB(:, :, 2:3));
nrows = size(ab, 1);
ncols = size(ab, 2);
ab = reshape(ab, nrows*ncols, 2);
nColors = 3; % ��������� �� 3 ������ ������
[cluster_idx, cluster_center] = kmeans(ab, nColors, 'distance', 'sqEuclidean', ...
                                      'Replicates',3); % ���������� ������������� ������� k-������� ��� ���������� �������� �� 3 ��������, ��� ����� ���������� ���������� �������.

% ����������� ����� ������� ������� ����������� �� ������ ������ k-�������
pixel_labels = reshape(cluster_idx, nrows,ncols);
%figure(1), subplot(1,2,1), imshow(RGB); title('��������'); % ������� �� ����� �������� �����������, � �������� �� 3 �������� 

% ������ ���������������� ����������� �� ������ ��������
segmented_images = cell(1, 3);
rgb_label = repmat(pixel_labels, [1 1 3]); % ��������� �������� pixel_labels, ����� ��������� ������� �� ����������� �� ������
for k = 1 : nColors
  color = RGB; % ��������� ���� ������� � ��������� �����������
  color(rgb_label ~= k) = 0; % ���� ���� ������� �� ��������� � ������ �����, �� ������ ��� ������
  segmented_images{k} = color; % ���� ���������, �� ��������� �������� ���� ����
end

% ������� ������ ��� ���� ��������
mean_cluster_val = zeros(3, 1);
for k = 1:nColors
  mean_cluster_val(k) = mean(cluster_center(k)); % ������ ��������, ������� �������� ����� �������
end
[mean_cluster_val,idx] = sort(mean_cluster_val);

% �������� cluster_center �������� ������� �������� 'a*' � 'b*' ��� ������� ��������. Ҹ���� ������� ����� 3�� ���������� �������� cluster_center.
brown_cluster_num = idx(3);

[height, width, dim] = size(segmented_images{brown_cluster_num}); % ���������� ������� ����������� � ��������� ������� (3, �� RGB) 

% ����������� ���������������� ������� ����������� ������� � �����. � �������� ������, � ����� � ��������
GR = rgb2gray(segmented_images{brown_cluster_num});
BW = imbinarize(GR);

%subplot(1,2,2), imshow(BW), title('��������');

octagon = strel('octagon',6)
bw_octagon = imerode(BW, octagon); % �������� �������� ��������� �������� �����������, �.�. �������� ������ ������ �������� � ���
se = strel('octagon',90);
closeBW = imclose(bw_octagon, se); % ��������� ��������������� �������� ��������� �����������, �.�. ��������� ������� � ������� ����� ��������

BWdfill = imfill(closeBW, 'holes'); % �������� ���������� ����, ������������ � ���� ���������� �������������� ��������

%figure(3)
%montage({BW, bw_octagon, closeBW }) % ���������� � ����� ���� ��������, ��������� �� ���� � �������� �����������

figure();
subplot(1,3,1), imshow(RGB), title('��������');
subplot(1,3,2), imshow(BW), title('��������');
subplot(1,3,3), imshow(BWdfill), title('��������');

p = BWdfill(:,:,1);  % �������� � ������� � �������� �������� �� ������� ��������� ����������� BW
p = double(p);  % ����������� �� �� ���� logic � doubl� ��� ���������� ������ � ����
for i = height+1:width
   for j = 1:width
       p(i,j) = 0;  % ���� ��� �������� ���������� ������� (���� ���������� 1(�� ������ �����) � ����� �������), �� ������� ������ ���� ����������
   end
end