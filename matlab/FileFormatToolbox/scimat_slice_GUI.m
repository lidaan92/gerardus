function scimat_slice_GUI(scimat)
% SCIMAT_SLICE_GUI  Create graphical user interface to view slices in
% scimat struct. Checkboxes allow for slice visibility to be turned on/off
%
% SCIMAT_SLICE_GUI(SCIMAT)
%
% SCIMAT is a struct with the image and axis metadata, i.e. spacing,
%   offset and orientation (see "help scimat" for details).

% Author: Christopher Kelly <christopher.kelly28@googlemail.com>
% Copyright � 2015 University of Oxford
% Version: 0.1.1
%
% University of Oxford means the Chancellor, Masters and Scholars of
% the University of Oxford, having an administrative office at
% Wellington Square, Oxford OX1 2JD, UK.
%
% This file is part of Gerardus.
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details. The offer of this
% program under the terms of the License is subject to the License
% being interpreted in accordance with English Law and subject to any
% action against the University of Oxford being under the jurisdiction
% of the English Courts.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

% check arguments
narginchk(1, 1);
nargoutchk(0, 0);

% create figure
f = figure('Visible','on','Position',[360,500,450,285],'Toolbar','figure');

handles.ha = axes('Units','normalized','Position',[0.1,0.1,0.5,0.8]);

% generate original surface visualizations and create checkboxes
for i = 1:numel(scimat)

    % we need the in-plane indices to be 'min', but the slice-selection
    % index to be 'offset' (in the middle of the slice)
    im_to_display = double(scimat(i).data(:,:,1,1));

    % this adds a row and columns of zeros, but they never get displayed
    im_to_display(end+1, end+1) = 0;

    [Nr, Nc, ~] = scimat(i).axis.size; % assume one slice per scimat element
    [R, C, S] = ndgrid(0.5:Nr+0.5, 0.5:Nc+0.5, 1); % the corners in x and y, center of z

    xyz = scimat_index2world([R(:), C(:), S(:)], scimat(i));

    X = reshape(xyz(:,1), size(R));
    Y = reshape(xyz(:,2), size(C));
    Z = reshape(xyz(:,3), size(S));


    axes(handles.ha);
    handles.im(i) = surface(X,Y,Z,im_to_display,'edgecolor','none');
    axis equal; grid on;
    colormap gray;

    sB(i) = uicontrol( 'Parent', f, 'Style', 'checkbox', 'String', ['slice ',num2str(i)], 'Value', 1, 'Units','normalized', ...
                       'Position', [0.7 1-(((0.9/numel(scimat))*(i-1)) + (0.9/numel(scimat))) 0.1 0.05],...
                       'Callback', {@checkBoxCallback,i,handles});

end

% get and set axis dimensions;
axis square;
view(3)
% axis;
% axis(ans);

% checkbox callback function
 function checkBoxCallback(hObject,eventData,checkBoxId,handles)

     % get value of checkbox
    value = get(hObject,'Value');

    % set visibility of slice surface based on checkbox value
    if value == 0
        set(handles.im(checkBoxId),'Visible','off');
    elseif value == 1
        set(handles.im(checkBoxId),'Visible','on');
    end
