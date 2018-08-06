
#ifndef PLANEMODEL_H
#define PLANEMODEL_H

#include "../stdutil/stdutil.h"

#include "model.h"
#include "brush.h"

class PlaneModel : public Model{
public:
	PlaneModel( int sub_divs );
	PlaneModel( const PlaneModel &t );
	~PlaneModel();
    virtual Object* clone(){ return d_new PlaneModel( *this ); }

	//model interface
	bool render( const RenderContext &rc );

	//object interface
	bool collide( const Line &line,float radius,Collision *curr_coll,const Transform &tf );

	Plane getRenderPlane()const;

private:
	struct Rep;

	Rep *rep;

	virtual PlaneModel *getPlaneModel(){ return this; }
};

#endif