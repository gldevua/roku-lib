'RlImage represents an image in 2D space. Lazy allocation of bitmap to reduce memory use (only allocated when first drawn).
'@param path a roBitmap/roRegion object or a String specifying an image path
'@param x the x coordinate
'@param y the y coordinate
'@param width the width
'@param height the height
'@return an Image object
function RlImage(path as Dynamic, x as Integer, y as Integer, width = invalid as Dynamic, height = invalid as Dynamic) as Object
    if type(path) = "String" 'If bitmap is a path, initialize a new bitmap. Otherwise bitmap should be a roBitmap or roRegion object
        bitmap = invalid
    else if type(path) = "roBitmap"
        bitmap = path
        path = invalid
    end if
    
    this = {
        type: "RlImage"
        bitmap: bitmap
        path: path
        x: x
        y: y
        width: width
        height: height
        
        Draw: RlImage_Draw
        Deallocate: RlImage_Deallocate
    }
    
    return this
end function

'Draws this RlImage to the specified component.
'@param component a roScreen/roBitmap/roRegion object
'@param conservative if set to true, the associated roBitmap is immediately deallocated after drawing, if possible
'@return true if successful
function RlImage_Draw(component as Object, conservative = false as Boolean) as Boolean
    'Lazy allocation
    if m.bitmap = invalid
        m.bitmap = CreateObject("roBitmap", m.path)
    end if
    
    m.width = m.bitmap.GetWidth()
    m.height = m.bitmap.GetHeight()

    'Draw image
    if m.width <> m.bitmap.GetWidth() or m.height <> m.bitmap.GetHeight() 'Scaled draw
        scaleX = m.width / m.bitmap.GetWidth()
        scaleY = m.height / m.bitmap.GetHeight()
        success = component.DrawScaledObject(m.x, m.y, scaleX, scaleY, m.bitmap)
    else 'Normal draw
        print "x: " + tostr(m.x)
        print "y: " + tostr(m.y)
        success = component.DrawObject(m.x, m.y, m.bitmap)
    end if
    
    'Deallocate if on conservative mode
    if conservative
        m.Deallocate()
    end if
    
    return success
end function

'Deletes the reference to the associated roBitmap (may deallocate from memory depending on whether there are other references to that bitmap)
function RlImage_Deallocate() as Void
    m.bitmap = invalid
end function