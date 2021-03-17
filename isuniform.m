function out=isuniform(in,dim,all)
    %in={1 2 4; 1 2 3; 1 2 3};
    if exist('all','var') && ~isempty(all) && ( (isnumeric(all) && all==1) || (ischar(all) && strcmp(all,'all')) )
        bAll=1;
    else
        bAll=0;
    end
    if ~exist('dim','var') || isempty(dim)
        if islogical(in) || isnumeric(in) || ischar(in)
            out=compare_num_all(in);
        elseif iscell(in)
            out=compare_cell_all(in);
        end
    else
        if islogical(in) || isnumeric(in) || all(ischar(in))
            out=compare_num(in,dim);
        elseif iscell(in)
            out=compare_cell(in,dim);
        end
        if bAll
            out=all(out(:));
        end
    end
end
function out=compare_num_all(in)
    out=all(logical(~diff(in(:))));
end
function out=compare_cell_all(in)
    A=in{1};
    out=all(cellfun(@(x) isequal(x,A),in));
end
function out=compare_num(in,dim);
    out=all(logical(~diff(in,[],dim)),dim);
end
function out=compare_cell(in,dim)
    A=dimSliceSelect(in,dim,1);
    sz=size(in);
    if sz(dim) ~= 1
        sz(dim)=sz(dim)-1;
    end
    out=zeros(sz);
    col=zeros(size(sz));
    col(dim)=1;
    col=strrep(num2strSane(double(col)),'0',':');

    for i= 2:size(in,dim)
        tmp=cellfun(@(x,y) isequal(x,y),A,dimSliceSelect(in,dim,i));
        str=['out( ' strrep(col,'1',num2str(i-1)) ' ) = tmp;'];
        try
            eval(str);
        catch ME
            disp(['ERROR IN EVAL STRING: ' str]);
            rethrow(ME);
        end

    end
    out=all(out,dim);
end
