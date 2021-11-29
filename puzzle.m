function puzzle(vertical,horizontal,size_parts,file_path,original_addr)


image_files = dir(file_path);

feature_cell = cell(1000,29);%make table with puzzles parts and their features 
k = 1;
for i=3:numel(image_files)
    
    img = im2double(imread([file_path '\' image_files(i).name]));
    if(image_files(i).name == "Corner_1_1.tif")
        j = k;%top left corner ... we should find the number of top left corner picture in feature cell
    end
    feature_cell{k,1} = image_files(i).name;%name
    
%     catch features of first 3 rows of each puzzles parts 
    feature_cell{k,2} = get_feature_2(img(1:3,:,:),"ave");%feature >> average of whole pixels in img
    feature_cell{k,3} = get_feature_2(img(1:3,:,:),"hist");%feature >> hist of whole pixels in img
    feature_cell{k,4} = get_feature_2(img(1:3,:,:),"ave_color");%feature >> average of whole pixels in each color of img
    feature_cell{k,5} = get_feature_2(img(1:3,:,:),"hist_color");%feature >> hist of whole pixels in each color of img
    feature_cell{k,6} = get_feature_2(img(1,:,:),"img");%feature >> pixels of first row of img
    feature_cell{k,7} = get_feature_2(img(1:3,:,:),"imgradient");%feature >> [gmag_r,gdir_r,gmag_g,gdir_g,gmag_b,gdir_b] gradient direction and gradient magnitude of each color of img
    feature_cell{k,8} = get_feature_2(img(1:3,:,:),"LBP");%feature >> LBP of in each color of img
    
%     catch features of first 3 columns of each puzzles parts     
    feature_cell{k,9} = get_feature_2(img(:,1:3,:),"ave");%feature
    feature_cell{k,10} = get_feature_2(img(:,1:3,:),"hist");%feature
    feature_cell{k,11} = get_feature_2(img(:,1:3,:),"ave_color");%feature
    feature_cell{k,12} = get_feature_2(img(:,1:3,:),"hist_color");%feature
    feature_cell{k,13} = get_feature_2(img(:,1,:),"img");%feature
    feature_cell{k,14} = get_feature_2(img(:,1:3,:),"imgradient");%feature
    feature_cell{k,15} = get_feature_2(img(:,1:3,:),"LBP");%feature
    
%     catch features of last 3 rows of each puzzles parts   
    feature_cell{k,16} = get_feature_2(img(size_parts-2:size_parts,:,:),"ave");%feature
    feature_cell{k,17} = get_feature_2(img(size_parts-2:size_parts,:,:),"hist");%feature
    feature_cell{k,18} = get_feature_2(img(size_parts-2:size_parts,:,:),"ave_color");%feature
    feature_cell{k,19} = get_feature_2(img(size_parts-2:size_parts,:,:),"hist_color");%feature
    feature_cell{k,20} = get_feature_2(img(size_parts,:,:),"img");%feature
    feature_cell{k,21} = get_feature_2(img(size_parts-2:size_parts,:,:),"imgradient");%feature
    feature_cell{k,22} = get_feature_2(img(size_parts-2:size_parts,:,:),"LBP");%feature

%     catch features of last 3 columns of each puzzles parts 
    feature_cell{k,23} = get_feature_2(img(:,size_parts-2:size_parts,:),"ave");%feature
    feature_cell{k,24} = get_feature_2(img(:,size_parts-2:size_parts,:),"hist");%feature
    feature_cell{k,25} = get_feature_2(img(:,size_parts-2:size_parts,:),"ave_color");%feature
    feature_cell{k,26} = get_feature_2(img(:,size_parts-2:size_parts,:),"hist_color");%feature
    feature_cell{k,27} = get_feature_2(img(:,size_parts,:),"img");%feature
    feature_cell{k,28} = get_feature_2(img(:,size_parts-2:size_parts,:),"imgradient");%feature
    feature_cell{k,29} = get_feature_2(img(:,size_parts-2:size_parts,:),"LBP");%feature
    
    
    k = k+1;
end

img_new = (zeros(1200,1920,3));
% corner

img = im2double(imread([file_path '\' feature_cell{j,1}]));

img_new(1:size_parts,1:size_parts,1) = img(:,:,1);
img_new(1:size_parts,1:size_parts,2) = img(:,:,2);
img_new(1:size_parts,1:size_parts,3) = img(:,:,3);

% put first top corner of img_new 
% corner

arr_norms = [];%array that we put some feature norms with last img of ignore array in it 

x_pic = 2;%because we have putfirst part , we piece from second piece. we have the same as horizontal columns of pieces
y_pic = 1;%we should start from first row. we have the same as vertical rows of pieces

ignore = [];%we put the piece that its place has been recognized... we put each j which change in 'for' below.  
ignore = [ignore,j];


for pic_part_no = 1:horizontal*vertical
    arr_norms = [];
    if(x_pic >= 2 && x_pic <=horizontal && y_pic == 1)%we seperate first row of puzzle from others.
        feature_j = feature_cell{j,25};%catch features of j img from cell ... ave_color
        feature_j_2 = feature_cell{j,26};%hist_color
        feature_j_3 = feature_cell{j,28};%gradient
        feature_j_4 = feature_cell{j,29};%LBP
        feature_j_5 = feature_cell{j,27};%img
        
       
    for i=1:horizontal*vertical  %we survey all img pieces and catch correspond features from cell . then calculate norm of i and j img and append to arr_norms.
        if(sum(ignore(ignore==i))==0)%we choose the i img which is not in ignore array because ignore array elements have placed in the picture.
            feature_i = feature_cell{i,11};
            feature_i_2 = feature_cell{i,12};
            feature_i_3 = feature_cell{i,14};
            feature_i_4 = feature_cell{i,15};
            feature_i_5 = feature_cell{i,13};
            
            arr_norms = [arr_norms ; [i,mean([norm(feature_i_5 - feature_j_5),norm(feature_i - feature_j),norm(feature_i_2 - feature_j_2),norm(feature_i_3 - feature_j_3),norm(feature_i_4 - feature_j_4)])]];
        end
    end
    arr_norms = sortrows(arr_norms,2);%finally sort this array of norms in ascending form to catch the smallest one .
    img = im2double(imread([file_path '\' feature_cell{arr_norms(1,1),1}]));
    img_new(size_parts*(y_pic-1)+1:size_parts*y_pic,size_parts*(x_pic-1)+1:size_parts*(x_pic),1)= img(:,:,1);%put the first img of arr_norms in img_new 
    img_new(size_parts*(y_pic-1)+1:size_parts*y_pic,size_parts*(x_pic-1)+1:size_parts*(x_pic),2)= img(:,:,2); 
    img_new(size_parts*(y_pic-1)+1:size_parts*y_pic,size_parts*(x_pic-1)+1:size_parts*(x_pic),3)= img(:,:,3);
    
    if(x_pic ~=horizontal)
        x_pic = x_pic + 1;
    else
        x_pic = 1;
        y_pic = 2;
    end
    j = arr_norms(1,1);
    ignore = [ignore,j];
    
    
    elseif(x_pic >= 2 && x_pic <=horizontal && y_pic>= 2 && y_pic<=vertical)%-------------------------------------------------------------------------------------------------------
        feature_j = feature_cell{j,25};
        feature_j_2 = feature_cell{j,26};
        feature_j_3 = feature_cell{j,28};
        feature_j_4 = feature_cell{j,29};
        feature_j_5 = feature_cell{j,27};
        
       
        for i=1:horizontal*vertical
            if(sum(ignore(ignore==i))==0)%we use upper img and left img of piece (i) to choose best one.
                feature_i = feature_cell{i,11};
                feature_i_2 = feature_cell{i,12};
                feature_i_3 = feature_cell{i,14};
                feature_i_4 = feature_cell{i,15};
                feature_i_5 = feature_cell{i,13};
                
                feature_jj = feature_cell{ignore(end-(horizontal-1)),18};
                feature_jj_2 = feature_cell{ignore(end-(horizontal-1)),19};
                feature_jj_3 = feature_cell{ignore(end-(horizontal-1)),21};
                feature_jj_4 = feature_cell{ignore(end-(horizontal-1)),22};
                feature_jj_5 = feature_cell{ignore(end-(horizontal-1)),20};
                
                feature_ii = feature_cell{i,4};
                feature_ii_2 = feature_cell{i,5};
                feature_ii_3 = feature_cell{i,7};
                feature_ii_4 = feature_cell{i,8};
                feature_ii_5 = feature_cell{i,6};
                
                mean_up = mean([norm(feature_ii_5 - feature_jj_5),norm(feature_ii - feature_jj),norm(feature_ii_2 - feature_jj_2),norm(feature_ii_3 - feature_jj_3),norm(feature_ii_4 - feature_jj_4)]);
                mean_left = mean([norm(feature_i_5 - feature_j_5),norm(feature_i - feature_j),norm(feature_i_2 - feature_j_2),norm(feature_i_3 - feature_j_3),norm(feature_i_4 - feature_j_4)]);
                
                arr_norms = [arr_norms ; [i,mean([mean_left,mean_up])]];

            end
        end
        arr_norms = sortrows(arr_norms,2);
        img = im2double(imread([file_path '\' feature_cell{arr_norms(1,1),1}]));
        img_new(size_parts*(y_pic-1)+1:size_parts*y_pic,size_parts*(x_pic-1)+1:size_parts*(x_pic),1)= img(:,:,1); 
        img_new(size_parts*(y_pic-1)+1:size_parts*y_pic,size_parts*(x_pic-1)+1:size_parts*(x_pic),2)= img(:,:,2); 
        img_new(size_parts*(y_pic-1)+1:size_parts*y_pic,size_parts*(x_pic-1)+1:size_parts*(x_pic),3)= img(:,:,3); 
        if(x_pic ~=horizontal)
            x_pic = x_pic + 1;
        else
            x_pic = 1;
            if(y_pic ~=vertical)
            y_pic = y_pic + 1;
            else
                break;
            end
        end
        j = arr_norms(1,1);
        ignore = [ignore,j];
        
        
    elseif(x_pic == 1 )%---------------------------------------------if our column is one, we can only use upper img in img_new to choose the best answer-----------------------------------------------------------------------------
        feature_j = feature_cell{ignore(end-(horizontal-1)),18};
        feature_j_2 = feature_cell{ignore(end-(horizontal-1)),19};
        feature_j_3 = feature_cell{ignore(end-(horizontal-1)),21};
        feature_j_4 = feature_cell{ignore(end-(horizontal-1)),22};
        feature_j_5 = feature_cell{ignore(end-(horizontal-1)),20};
       
    for i=1:horizontal*vertical
        if(sum(ignore(ignore==i))==0)
            feature_i = feature_cell{i,4};
            feature_i_2 = feature_cell{i,5};
            feature_i_3 = feature_cell{i,7};
            feature_i_4 = feature_cell{i,8};
            feature_i_5 = feature_cell{i,6};
            
            arr_norms = [arr_norms ; [i,mean([norm(feature_i_5 - feature_j_5),norm(feature_i - feature_j),norm(feature_i_2 - feature_j_2),norm(feature_i_3 - feature_j_3),norm(feature_i_4 - feature_j_4)])]];
        end
    end
    arr_norms = sortrows(arr_norms,2);
    img = im2double(imread([file_path '\' feature_cell{arr_norms(1,1),1}]));
    img_new(size_parts*(y_pic-1)+1:size_parts*y_pic,size_parts*(x_pic-1)+1:size_parts*(x_pic),1)= img(:,:,1); 
    img_new(size_parts*(y_pic-1)+1:size_parts*y_pic,size_parts*(x_pic-1)+1:size_parts*(x_pic),2)= img(:,:,2); 
    img_new(size_parts*(y_pic-1)+1:size_parts*y_pic,size_parts*(x_pic-1)+1:size_parts*(x_pic),3)= img(:,:,3); 
    
    x_pic = 2;
    
    j = arr_norms(1,1);
    ignore = [ignore,j];
    
    
    end
    imshow(img_new,[]);
end

main_picture = im2double(imread(original_addr));
    
mse1 = My_MSE(main_picture(:,:,1),img_new(:,:,1));
mse2 = My_MSE(main_picture(:,:,2),img_new(:,:,2));
mse3 = My_MSE(main_picture(:,:,3),img_new(:,:,3));

display("MSE : "+num2str(mean([mse1,mse2,mse3])));

imshow(img_new,[]);



end












