function parsedlink = get_parsedlink(str, handles)
    if ~strcmp(str, 'null')
%turn linking string for molecule into useful search term in linking table
        L = findstr('LL:', str);
        U = findstr('UP:', str);
        C = findstr(',', str);

        if L
            for i = 1:length(L)
                start = L(i) + 3;
                if length(C)>=i
                    parsedlink{i,1} = (str(start:C(i) - 1));
                    parsedlink{i,2} = 2;
                else
                    parsedlink{i,1} = (str(start:end)); 
                    parsedlink{i,2} = 2;
                end
            end
            
        elseif U
            for i = 1:length(U)
                start = U(i) + 3;
                if length(C)>=i
                    parsedlink{i,1} = str(start:C(i) - 1);
                    parsedlink{i,2} = 3;
                else
                    parsedlink{i,1} = str(start:end);
                    parsedlink{i,2} = 3;
                end
            end
            
        else 
            parsedlink = {[] []};
        end


for pl = 1:size(parsedlink,1)
        try
            if parsedlink{pl,2} ==3
                parsedlink{pl,2} = handles.PwData.UP2LL{strmatch(parsedlink{pl,1}, handles.PwData.UP2LL(:,1)), 2};
            
            %pnames = probe_links(strmatch(parsedlink{pl,1}, probe_links(:,2), 'exact'),1);
            %for pn = 1:length(pnames)
               % proberows = [proberows; strmatch(pnames{pn}, handles.DataStruct(1).Rows, 'exact');];
            %end
            else
                parsedlink{pl,2} = str2num(parsedlink{pl,1});
             end
        catch
        end
 end
   parsedlink = unique([parsedlink{:,2}]);
    else
        parsedlink=[];
    end
end
    