using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Screenshoter : MonoBehaviour
{
    #if UNITY_EDITOR
    [UnityEditor.MenuItem("Tools/Take Screenshot")]
#endif
    public static void TakeScreenshot()
    {
        ScreenCapture.CaptureScreenshot($"./screenshot_{DateTime.Now.ToFileTimeUtc().ToString()}.png");
    }
}
