#ifndef CLASS2_H
#define CLASS2_H

#include <QObject>
#include <QDebug>

class class2 : public QObject
{
    Q_OBJECT
public:
    class2();

public:
    void print() {
        qDebug() << "I have printed";
    }
};

#endif // CLASS2_H
