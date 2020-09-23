/*
 * Copyright (C) 2016 The Qt Company Ltd.
 * Copyright (C) 2019 Konsulko Group
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <QGuiApplication>
#include <QtQml/QQmlApplicationEngine>
#include <QtQml/QQmlContext>
#include <QtGui/QGuiApplication>
#include <QtCore/QCommandLineParser>
#include <QtCore/QUrlQuery>
#include <signalcomposer.h>
#include "translator.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setDesktopFileName("dashboard");

    QCommandLineParser parser;
    parser.addPositionalArgument("port", app.translate("main", "port for binding"));
    parser.addPositionalArgument("secret", app.translate("main", "secret for binding"));
    parser.addHelpOption();
    parser.addVersionOption();
    parser.process(app);
    QStringList positionalArguments = parser.positionalArguments();
    if (positionalArguments.length() != 2) {
        exit(EXIT_FAILURE);
    }

    int port = positionalArguments.takeFirst().toInt();
    QString secret = positionalArguments.takeFirst();
    QUrlQuery query;
    query.addQueryItem(QStringLiteral("token"), secret);

    QUrl bindingAddress;
    bindingAddress.setScheme(QStringLiteral("ws"));
    bindingAddress.setHost(QStringLiteral("localhost"));
    bindingAddress.setPort(port);
    bindingAddress.setPath(QStringLiteral("/api"));
    bindingAddress.setQuery(query);

    QQmlApplicationEngine engine;
    QQmlContext *context = engine.rootContext();
    context->setContextProperty("SignalComposer", new SignalComposer(bindingAddress, context));
    qmlRegisterType<Translator>("Translator", 1, 0, "Translator");
    engine.load(QUrl(QStringLiteral("qrc:/Dashboard.qml")));
    return app.exec();
}

