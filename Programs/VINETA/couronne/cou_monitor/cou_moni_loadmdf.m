function [mat, tvec] = cou_moni_loadmdf_new(basedir, namevec, tlen)

    if basedir(end) ~= '\', basedir= [basedir, '\']; end
    mat= [];
    for i1= 1:length(namevec)
        name= cell2mat(namevec{length(namevec)-i1+1});
        [mat_8, tvec] = readmdf_quick([basedir, name], tlen);
        mat= [mat, mat_8];
    end
    
end