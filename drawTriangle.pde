

void drawTriangle(float x, float y, float l) {
    pushMatrix();

    translate(x-l/2, y-l/2);
    beginShape(TRIANGLES);
    vertex(l, l);
    vertex(l/2, 0);
    vertex(0, l);
    endShape();
    popMatrix();
}

