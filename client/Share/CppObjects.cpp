#include "CppObjects.hpp"

#include <QClipboard>

// Функция копирования значения в буфер обмена
void CppObjects::copyToClipBoard(QString value) { _app->clipboard()->setText(value); }
