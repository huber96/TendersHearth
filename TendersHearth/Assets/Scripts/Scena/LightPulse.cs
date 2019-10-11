using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LightPulse : MonoBehaviour
{
    [SerializeField] [Range(0, 3)] private float intensityMultiplier = 1.5f;
    [SerializeField] [Range(0, 3)] private float flickerSpeed = 0.5f;

    private Light lightSource;

    private void Start()
    {
        lightSource = GetComponent<Light>();
    }

    private void Update()
    {
        float val = Mathf.Sin(Time.time * flickerSpeed);

        val = Mathf.Exp(val);

        lightSource.intensity = val * intensityMultiplier;
    }
}
