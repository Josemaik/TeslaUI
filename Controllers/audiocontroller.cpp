#include "audiocontroller.h"


AudioController::AudioController(QObject *parent)
    : QObject{parent}
    , m_volumeLevel(51)
{

}

int AudioController::volumeLevel() const
{
    return m_volumeLevel;
}

void AudioController::incrementVolume(const int &val)
{
    int newvolume = m_volumeLevel + val;

    if(newvolume <= 0)
    {
        newvolume = 0;
    }

    if(newvolume >= 100)
    {
        newvolume = 100;
    }

    setVolumeLevel(newvolume);
}

void AudioController::setVolumeLevel(int newVolumeLevel)
{
    if (m_volumeLevel == newVolumeLevel)
        return;
    m_volumeLevel = newVolumeLevel;
    emit volumeLevelChanged();
}
