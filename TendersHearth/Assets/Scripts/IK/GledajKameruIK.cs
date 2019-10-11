using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GledajKameruIK : MonoBehaviour
{
    private Vector3 lookTarget;
    private Animator avatar;

    public static bool enableIK = true;

    [Header("IK weight")]
    [Range(0, 1)] [SerializeField] private float weight = 1;
    [Range(0, 1)] [SerializeField] private float bodyWeight = 0.15f;
    [Range(0, 1)] [SerializeField] private float headWeight = 0.65f;
    [Range(0, 1)] [SerializeField] private float eyesWeight = 0;
    [Range(0, 1)] [SerializeField] private float clampWeight = 0.75f;


    private void Start()
    {
        avatar = GetComponent<Animator>();
    }

    private void OnAnimatorIK(int layerIndex)
    {
        if (avatar == null || enableIK == false)
            return;

        avatar.SetLookAtWeight(weight, bodyWeight, headWeight, eyesWeight, clampWeight);
        avatar.SetLookAtPosition(Camera.main.transform.position);
    }
}
