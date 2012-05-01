

class element {

    color selectedBackgroundColor;
    color unselectedBackgroundColor;
    color selectedFontColor;
    color unselectedFontColor;

    int   isSelected;        ///< 0 not selected, 1 selected
    float positionX;
    float positionY;
    float textX;
    float textY;
    float width;
    float height;
    float textMargin;

    String description;

    element() {

        selectedBackgroundColor = #CBD4D8;
        unselectedBackgroundColor = #ABB5BD;
        selectedFontColor = #000000;
        unselectedFontColor = #ffffff;
        description = "NULL";
        textMargin = 20;
    }

    void display() {

        color backgroundColor;
        color fontColor;

        if (isSelected == 1) {
            dataYmin = minElement();
            dataYmax = 1.2*maxElement();
            backgroundColor = selectedBackgroundColor;
            fontColor = selectedFontColor;
        }
        else {
            backgroundColor = unselectedBackgroundColor;
            fontColor = unselectedFontColor;
        }  

        textFont(selectFont, 17);
        rectMode(CORNER);
        fill(backgroundColor);
        rect(positionX, positionY, width, height);

        fill(fontColor);
        textAlign(LEFT);
        text(description, positionX, positionY+30);
    }

    ///
    /// Set the array element at position 0 to desired location.
    ///
    void setBegin(float x, float y, float xWidth) {

        positionX = x;
        positionY = y;
        textX = positionX;
        textY = positionY + 30;
        textFont(selectFont, 17);
        width = xWidth;
        height = 50;
    }

    ///
    /// 0 no hover, 1 mouse hover
    ///
    int isHover() {


        if (mouseX > positionX && mouseX < positionX+width) {
            if (mouseY > positionY && mouseY < positionY+height) {
                return 1;
            }
        }

        return 0;
    }
}

