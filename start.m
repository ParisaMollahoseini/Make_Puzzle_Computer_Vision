clc;
close all
clear ;

name = 'Puzzle_1_40';
address = 'patch'; 
original_address = 'Original.tif';


str = strfind(name,'_');
piece_no = str2num(name(str(end)+1:end));

display(piece_no);

vertical = sqrt(piece_no/40)*5;
horizontal = sqrt(piece_no/40)*8;

size_parts = 1920/horizontal;

puzzle(vertical,horizontal,size_parts,address,original_address);