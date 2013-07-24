'General drawing utilities

'Draws all objects in the given array, in order, to a component
'@param array a roArray object
'@param component a roScreen/roBitmap/roRegion object
'@return true if successful
function RlDrawAll(array as Object, component as Object) as Boolean
    max = array.Count() - 1
    for i = 0 to max
        item = array[i]
        if item <> invalid and not item.Draw(component) then return false
    end for
    return true
end function