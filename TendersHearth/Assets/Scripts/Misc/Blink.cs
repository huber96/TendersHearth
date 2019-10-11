using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Blink : MonoBehaviour
{
    private float blinkTimer;
    private float disabledTimer;

    private SkinnedMeshRenderer mr;

    private bool isBlinking = false;

    private void Start()
    {
        mr = GetComponent<SkinnedMeshRenderer>();
        blinkTimer = Random.Range(1, 15);
        disabledTimer = 0;
    }

    private void Update()
    {
        if (blinkTimer > 0)
        {
            blinkTimer -= Time.deltaTime;
        }
        else if (isBlinking == false)
        {
            isBlinking = true;
            disabledTimer = 0.25f;
            mr.SetBlendShapeWeight(0, 100);
        }

        if (disabledTimer > 0)
        {
            disabledTimer -= Time.deltaTime;
        }
        else if (isBlinking == true)
        {
            isBlinking = false;
            blinkTimer = Random.Range(1, 15);
            mr.SetBlendShapeWeight(0, 0);
        }

    }
}
