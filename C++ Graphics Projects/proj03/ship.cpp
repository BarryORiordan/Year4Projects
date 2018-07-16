/*
 * CS4085: Skeleton for lab assignment.
 *
 * Copyright (C) 2008 Jacek Rosik <jacek.rosik@ul.ie>
 */


#include <cassert>
#include <cmath>

#include <osg/Geode>
#include <osg/Quat>
#include <osg/Shape>
#include <osg/ShapeDrawable>
#include <osg/MatrixTransform>

#include "ship.h"

bool on;

Ship::Ship(osg::MatrixTransform *visual):
    Entity(visual), _lastFrame(0.0),
    _power(1.0), _velocity(0.0, 0.0, 0.0)
{
    /* All engines initially disabled.  */
    _engines[0] = false;
    _engines[1] = false;
    _engines[2] = false;
    _engines[3] = false;
    _engines[4] = false;
    _engines[5] = false;
}


Ship *
Ship::create()
{
    osg::ref_ptr<osg::MatrixTransform> visual = new osg::MatrixTransform();

    /* Create visual representation of the ship.  */
    osg::ref_ptr<osg::Shape> shape = new osg::Box(osg::Vec3(0.0, 0.0, 0.0),  1.0);
    //shape->setRotation(osg::Quat(0.5 * M_PI, osg::Vec3(1.0, 0.0, 0.0)));

    osg::ref_ptr<osg::Geode>    geode = new osg::Geode;
    geode->addDrawable(new osg::ShapeDrawable(shape.get()));
    visual->addChild(geode.get());

    return new Ship(visual.get());
}


void
Ship::activateEngine(Engine engine, bool activate)
{
    /* Enable/Disable given engine.  */
    assert(engine >= LEFT_ENGINE && engine <= DECELERATOR);
    _engines[engine] = activate;
    if(_engines[engine] == ACCELERATOR)
    {

    }
    else if(_engines[engine] == DECELERATOR)
    {

    }
    else
    {

    }

}



void
Ship::translate(const osg::Vec3 translation)
{
    osg::Matrix matrix;
    matrix.makeTranslate(translation);
    _visual->postMult(matrix);
}


void
Ship::rotate(double angle)
{
    osg::Matrix matrix;
    matrix.makeRotate(angle, osg::Vec3(0.0, 0.0, 1.0));
    _visual->postMult(matrix);
}

const osg::Vec3
Ship::getPosition(void) const
{
    osg::Vec3 trans, vdummy;
    osg::Quat qdummy;
    _visual->getMatrix().decompose(trans, qdummy, vdummy, qdummy);

    return trans;
}


double
Ship::getOrientation(void) const
{
    double angle;
    osg::Vec3 vdummy;
    osg::Quat rot, qdummy;
    _visual->getMatrix().decompose(vdummy, rot, vdummy, qdummy);
    rot.getRotate(angle, vdummy);

    return angle;
}



void
Ship::onUpdate(double time)
{
    double delta = time - _lastFrame;
    _lastFrame = time;

    /* Get the force vector first.  */
    osg::Vec3 force(0.0, 0.0, 0.0);
    if (_engines[LEFT_ENGINE])
        force += osg::Vec3(1.0, 0.0, 0.0);
    if (_engines[TOP_ENGINE])
        force += osg::Vec3(0.0, -1.0, 0.0);
    if (_engines[RIGHT_ENGINE])
        force += osg::Vec3(-1.0, 0.0, 0.0);
    if (_engines[BOTTOM_ENGINE])
        force += osg::Vec3(0.0, 1.0, 0.0);
    force *= _power;

    /* Update ship's position.  */
    translate(_velocity * delta);

    /* Caluclate ship's new velocity.  */
    _velocity += force * delta;
    //printf("VELOCITY: %f %f %f\n", _velocity[0], _velocity[1], _velocity[2]);
}


/* vi:set tw=78 sw=4 ts=4 et: */
