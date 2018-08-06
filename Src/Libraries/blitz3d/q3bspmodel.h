
#ifndef Q3BSPMODEL_H
#define Q3BSPMODEL_H

#include "../stdutil/stdutil.h"

#include "model.h"

class Q3BSPModel : public Model{
public:
	Q3BSPModel( String f,float gamma_adj );
	Q3BSPModel( const Q3BSPModel &m );
	~Q3BSPModel();

	//Entity interface
    virtual Object* clone(){ return d_new Q3BSPModel( *this ); }

	//Object interface
	virtual bool collide( const Line &line,float radius,Collision *curr_coll,const Transform &t );

	//Model interface
	Q3BSPModel *getBSPModel(){ return this; }

	bool render( const RenderContext &rc );

	void setAmbient( const Vector &t );
	void setLighting( bool use_lmap );

	bool isValid()const;

private:
	struct Rep;
	Rep *rep;
};

#endif