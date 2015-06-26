clear;
close all;




for CLUST = 5
    
%%%%%% main settings
numOfClusters = CLUST; 
min = -400;
max = 400;


%%%%%% prep. images
A = OM_DICOMPixels('A');
B = OM_DICOMPixels('B');
C = -1024*ones(size(A));
[n, m] = size(A);


%%%%%% prepare for clustering
tempX = zeros(size(A));
tempY = tempX;
for i = 1:n
    for k = 1:m
        tempX(i,k) = i;
        tempY(i,k) = k;
    end
end

tempA = [A(:) tempX(:) tempY(:)];
tempIdxA = 1:length(tempA);
tempIdxA = tempIdxA(tempA(:,1) > min & tempA(:,1) < max);
tempA = tempA(tempA(:,1) > min & tempA(:,1) < max,:);

tempB = [B(:) tempX(:) tempY(:)];
tempIdxB = 1:length(tempB);
tempIdxB = tempIdxB(tempB(:,1) > min & tempB(:,1) < max);
tempB = tempB(tempB(:,1) > min & tempB(:,1) < max,:);

for i = 1:3
    tempA(:,i) = (tempA(:,i) - mean(tempA(:,i))) / std(tempA(:,i));
    tempB(:,i) = (tempB(:,i) - mean(tempB(:,i))) / std(tempB(:,i));
end


%%%%%% clustering
clustA = zeros(length(A(:)),1);
clustB = zeros(length(B(:)),1);
clustA(tempIdxA) = kmeans(tempA,numOfClusters,'MaxIter',1000);
clustB(tempIdxB) = kmeans(tempB,numOfClusters,'MaxIter',1000);


%%%%%% matching clusters
idx1 = zeros(numOfClusters,2);
idx2 = idx1;
for i = 1:numOfClusters
    idx1(i,1) = i;
    idx1(i,2) = mean(A(clustA == i));
    idx2(i,1) = i;
    idx2(i,2) = mean(B(clustB == i));
end
idx1 = sortrows(idx1,2);
idx2 = sortrows(idx2,2);


%%%%%% finding centroids
X1 = zeros(numOfClusters,1);
X2 = X1;
Y1 = X1;
Y2 = X1;


figure(1);
subplot(121); 
imshow(A,[-200 200]);
subplot(122); hold on;


for i = 1:numOfClusters
    i
    [row, col] = find(reshape(clustA == idx1(i,1),size(A)));
    X1(i) = mean(row);
    Y1(i) = mean(col);
    
    if i == 1
        plot(col,-row,'r*'); 
    elseif i == 2
        plot(col,-row,'g*'); 
    elseif i == 3
        plot(col,-row,'b*'); 
    elseif i == 4
        plot(col,-row,'y*');
    elseif i == 5
        plot(col,-row,'c*'); 
%     elseif i == 6
%         plot(col,-row,'m*'); 
    end
    
    [row, col] = find(reshape(clustB == idx2(i,1),size(B)));
    X2(i) = mean(row);
    Y2(i) = mean(col);
end




% %%%%%% finding transformation
% regX = regress(X2, [X1 Y1 ones(numOfClusters,1)]);
% regY = regress(Y2, [X1 Y1 ones(numOfClusters,1)]);
% T = [regX'; regY'];
% 
% 
% %%%%%% transforming
% for i = 1:n
%     for k = 1:m
%         if A(i,k) ~= -1024       
%             q = [i k 1];
%             p = round(T * [i; k; 1]);
%             if p(1) > 0 && p(2) > 0 && p(1) < n && p(2) < m
%                 C(p(1),p(2)) = A(i,k);
%             end
%         end
%     end    
% end
% 
% 
% %%%%%% comparison of images
% % figure(1);
% % subplot(121); imshow(A,[-200 200]);
% % subplot(122); imshow(B,[-100 100]);
% % figure(CLUST);
% % subplot(121); imshow(C,[-200 200]);
% % subplot(122); imshow(B,[-100 100]);
% 
% % figure();
% % imshow(C,[-200 200]);
% % figure();
% % imshow(C-B,[-100 100]);
% 
% 
% %%%%%% show T and eigenvalues
% T
% eig(T(1:2,1:2))
end