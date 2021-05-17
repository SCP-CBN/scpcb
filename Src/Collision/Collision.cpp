/**

Blitz3D is released under the zlib/libpng license.

Altered to utilize pge's math classes

The zlib/libpng License

Copyright (c) 2013 Blitz Research Ltd

This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.

2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.

3. This notice may not be removed or altered from any source distribution.

**/

#include "Collision.h"
#include <Math/Plane.h>

#include <math.h>

#include <iostream>

using namespace PGE;

constexpr float COLLISION_EPSILON = 0.001f;

Collision::Collision() { coveredAmount = 1.0f; hit = false; }

Collision::Collision(const Collision& other) {
    line = other.line;
    coveredAmount = other.coveredAmount;
    normal = other.normal;
    surfaceNormal = other.surfaceNormal;
    hit = other.hit;
}

Collision Collision::update(const Line3f& line,float t,const Vector3f& n) {
    Collision retVal;
    retVal.hit = false;

    if (t<0.f || t>1.f) { return retVal; }

    Plane p = Plane(n,(line.pointB - line.pointA) * t + line.pointA);
    if (p.normal.dotProduct(line.pointB - line.pointA)>=0) { return retVal; }
    if (p.evalAtPoint(line.pointA)<-COLLISION_EPSILON) { return retVal; }

    retVal.line = line;
    retVal.coveredAmount = t;
    retVal.normal = n.normalize();
    retVal.surfaceNormal = retVal.normal;
    retVal.hit = true;
    return retVal;
}

Collision Collision::sphereCollide(const Line3f& line,float radius,const Vector3f& otherPos,float other_radius) {
    Collision retVal;
    retVal.hit = false;

    radius+=other_radius;
    //Line3f l = Line3f(line.pointA.subtract(otherPos),line.pointB.subtract(otherPos));
    Vector3f lineDir = line.pointB - line.pointA;

    float a=lineDir.dotProduct(lineDir);
    if (fabs(a)<COLLISION_EPSILON) { return retVal; }
    float b=line.pointA.dotProduct(lineDir)*2;
    float c=line.pointA.dotProduct(line.pointA)-radius*radius;
    float d=b*b-4*a*c;
    if (d<0) { return retVal; }

    float t1=(-b+sqrt(d))/(2*a);
    float t2=(-b-sqrt(d))/(2*a);

    float t=t1<t2 ? t1 : t2;

    if (t<0.f || t>1.f) { return retVal; }

    if ((line.pointA + lineDir * t).length()<COLLISION_EPSILON) { return retVal; }
    return update(line,t,(line.pointA + lineDir * t).normalize());
}

//v0,v1 = edge verts
//pn = poly normal
//en = edge normal
Collision Collision::edgeTest(const Vector3f& v0,const Vector3f& v1,const Vector3f& pn,const Vector3f& en,const Line3f& line,float radius) {
    Collision retVal;
    retVal.hit = false;

    Vector3f tm0 = en.normalize();
    Vector3f tm1 = (v1 - v0).normalize();
    Vector3f tm2 = pn.normalize();

    Vector3f tm0Transposed = Vector3f(tm0.x,tm1.x,tm2.x);
    Vector3f tm1Transposed = Vector3f(tm0.y,tm1.y,tm2.y);
    Vector3f tm2Transposed = Vector3f(tm0.z,tm1.z,tm2.z);

    Vector3f sv = line.pointA - v0;
    sv = Vector3f(sv.dotProduct(tm0),sv.dotProduct(tm1),sv.dotProduct(tm2));
    Vector3f dv = line.pointB - v0;
    dv = Vector3f(dv.dotProduct(tm0),dv.dotProduct(tm1),dv.dotProduct(tm2)) - sv;

    //do cylinder test...
    float a,b,c,d,t1,t2,t;
    a=(dv.x*dv.x+dv.z*dv.z);
    if( !a ) { return retVal; }                    //ray parallel to cylinder
    b=(sv.x*dv.x+sv.z*dv.z)*2;
    c=(sv.x*sv.x+sv.z*sv.z)-radius*radius;
    d=b*b-4*a*c;
    if( d<0 ) { return retVal; }                    //ray misses cylinder
    t1=(-b+sqrt(d))/(2*a);
    t2=(-b-sqrt(d))/(2*a);
    t=t1<t2 ? t1 : t2;
    if( t>1.f ) { return retVal; }    //intersects too far away
    Vector3f i=sv + dv * t;
    Vector3f p=Vector3f::ZERO;
    if( i.y>v0.distance(v1) ) { return retVal; }    //intersection above cylinder
    if( i.y>=0 ){
        p.y=i.y;
    }else{
        //below bottom of cylinder...do sphere test...
        a=dv.dotProduct(dv);
        if( !a ) { return retVal; }                //ray parallel to sphere
        b=sv.dotProduct(dv)*2;
        c=sv.dotProduct(sv)-radius*radius;
        d=b*b-4*a*c;
        if( d<0 ) { return retVal; }                //ray misses sphere
        t1=(-b+sqrt(d))/(2*a);
        t2=(-b-sqrt(d))/(2*a);
        t=t1<t2 ? t1 : t2;
        if( t>1.f ) { return retVal; }
        i=sv + dv * t;
    }

    Vector3f n = i - p;
    n = Vector3f(n.dotProduct(tm0Transposed),n.dotProduct(tm1Transposed),n.dotProduct(tm2Transposed));
    return update(line,t,n);
}

Collision Collision::triangleCollide(const PGE::Line3f& line,float radius,const PGE::Vector3f& v0,const PGE::Vector3f& v1,const PGE::Vector3f& v2) {
    Collision retVal;
    retVal.hit = false;

    //triangle plane
    Plane p = Plane(v0,v1,v2);

    //move plane out
    p.distanceFromOrigin+=radius;
    float t = 1.f;

    //edge planes
    Plane p0( v0 + p.normal,v1,v0 );
    Plane p1( v1 + p.normal,v2,v1 );
    Plane p2( v2 + p.normal,v0,v2 );

    if (p.normal.dotProduct(line.pointB - line.pointA)<0.f) {
        t = -p.evalAtPoint(line.pointA)/p.normal.dotProduct(line.pointB - line.pointA);

        //intersects triangle?
        Vector3f i=(line.pointB - line.pointA) * t + line.pointA;

        float eval0 = p0.evalAtPoint(i);
        float eval1 = p1.evalAtPoint(i);
        float eval2 = p2.evalAtPoint(i);

        if (eval0>=0.f && eval1>=0.f && eval2>=0.f) {
            return update(line,t,p.normal);
        }
    }
    //if (t<0.f || t>1.f) { return retVal; }

    if (radius<=0) { return retVal; }

    Collision temp;
    temp = edgeTest(v0,v1,p.normal,p0.normal,line,radius);
    if (temp.hit) {
        retVal = temp;
    }
    temp = edgeTest(v1,v2,p.normal,p1.normal,line,radius);
    if (temp.hit) {
        if (!retVal.hit || retVal.coveredAmount>temp.coveredAmount) {
            retVal = temp;
        }
    }
    temp = edgeTest(v2,v0,p.normal,p2.normal,line,radius);
    if (temp.hit) {
        if (!retVal.hit || retVal.coveredAmount>temp.coveredAmount) {
            retVal = temp;
        }
    }

    retVal.surfaceNormal = p.normal;
    return retVal;
}

Collision Collision::triangleCollide(const Line3f& line,float height,float radius,const PGE::Vector3f& v0,const PGE::Vector3f& v1,const PGE::Vector3f& v2) {
    if (height<=radius) {
        return triangleCollide(line, radius, v0, v1, v2);
    }
    
    Collision retVal;
    retVal.hit = false;
    
    Vector3f forward = line.pointB - line.pointA;
    Vector3f upVector = Vector3f(0.f,1.f,0.f);

    if (abs(forward.normalize().dotProduct(upVector))>0.9999f) {
        forward.x = 0.f; forward.z = 0.f;
        Line3f newLine = Line3f(line.pointA,line.pointA + forward);

        if (forward.y>0.f) {
            newLine.pointA.y -= height*0.5f - radius;
            newLine.pointB.y += height*0.5f - radius;
        } else {
            newLine.pointA.y += height*0.5f - radius;
            newLine.pointB.y -= height*0.5f - radius;
        }

        retVal = triangleCollide(newLine, radius, v0, v1, v2);

        if (retVal.hit)
        {
            Vector3f diff = (newLine.pointB - newLine.pointA) * retVal.coveredAmount + newLine.pointA - line.pointA;
            if (forward.y>0.f) {
                diff.y -= height*0.5f - radius;
            } else {
                diff.y += height*0.5f - radius;
            }
            retVal.line = line;
            retVal.coveredAmount = diff.length()/line.pointB.distance(line.pointA);

            if (retVal.coveredAmount > 1.f) {
                retVal.hit = false;
            }
            if (retVal.coveredAmount < 0.f) {
                retVal.coveredAmount = 0.f;
            }
        }

        return retVal;
    }

    Vector3f forwardXZ = Vector3f(forward.x,0.f,forward.z);
    Vector3f planePoint = forwardXZ.normalize() * radius;

    Vector3f planeNormal = upVector.crossProduct(forward).crossProduct(forward).normalize();
    if (planeNormal.y<0.f) { planeNormal = -planeNormal; }

    Plane bottomPlane = Plane(planeNormal, line.pointA + Vector3f(0.f,-height*0.5f + radius,0.f) + planePoint);
    Plane topPlane = Plane(planeNormal, line.pointA + Vector3f(0.f,height*0.5f - radius,0.f) + planePoint);

    //cylinder collision
    //we only check for edges here because the sphere collision can handle the other case just fine
    Plane p = Plane(v0,v1,v2);

    Collision temp;
    temp.hit = false;

    Vector3f edgePoints[6] = { v0,v1,v1,v2,v2,v0 };

    Line3f newLine = Line3f(Vector3f(line.pointA.x,0.f,line.pointA.z),Vector3f(line.pointB.x,0.f,line.pointB.z));

    for (int i=0;i<6;i+=2) {
        Line3f edge = Line3f(edgePoints[i],edgePoints[i+1]);
        
        Vector3f edgePoint0; Vector3f edgePoint1;
        float coveredAmountTop = 0;
        float coveredAmountBottom = 0;
        
        bool intersectsTop = topPlane.getIntersectionPoint(edge, edgePoint0, coveredAmountTop, true, true);
        bool intersectsBottom = bottomPlane.getIntersectionPoint(edge, edgePoint1, coveredAmountBottom, true, true);
        if (intersectsTop && intersectsBottom) {
            if (coveredAmountTop < 0.f) {
                edgePoint0 = edge.pointA;
            } else if (coveredAmountTop > 1.f) {
                edgePoint0 = edge.pointB;
            }

            if (coveredAmountBottom < 0.f) {
                edgePoint1 = edge.pointA;
            } else if (coveredAmountBottom > 1.f) {
                edgePoint1 = edge.pointB;
            }
        } else {
            if (topPlane.evalAtPoint(edge.pointA)<=0.f && bottomPlane.evalAtPoint(edge.pointA)>=0.f) {
                edgePoint0 = edge.pointA;
                edgePoint1 = edge.pointB;
            } else {
                continue;
            }
        }

        if (edgePoint0.distanceSquared(edgePoint1) < 0.0000001f) {
            continue;
        }

        edgePoint0.y = 0.f; edgePoint1.y = 0.f;

        Plane edgePlane(edgePoint0 + upVector,edgePoint1,edgePoint0);

        temp = edgeTest(edgePoint0,edgePoint1,upVector,edgePlane.normal,newLine,radius);
        if (temp.hit) {
            if (!retVal.hit || retVal.coveredAmount>temp.coveredAmount) {
                retVal = temp;
            }
        }
    }

    Line3f bottomSphereLine = line;
    bottomSphereLine.pointA.y -= height*0.5f-radius;
    bottomSphereLine.pointB.y -= height*0.5f-radius;
    Line3f topSphereLine = line;
    topSphereLine.pointA.y += height*0.5f-radius;
    topSphereLine.pointB.y += height*0.5f-radius;

    Collision bottomCollision = triangleCollide(bottomSphereLine, radius, v0, v1, v2);
    Collision topCollision = triangleCollide(topSphereLine, radius, v0, v1, v2);

    if (bottomCollision.hit && (!retVal.hit || bottomCollision.coveredAmount < retVal.coveredAmount)) {
        retVal = bottomCollision;
        retVal.line = line;
    }
    if (topCollision.hit && (!retVal.hit || topCollision.coveredAmount < retVal.coveredAmount)) {
        retVal = topCollision;
        retVal.line = line;
    }

    if (retVal.hit) {
        retVal.surfaceNormal = p.normal;
        retVal.line = line;
    }

    return retVal;
}
