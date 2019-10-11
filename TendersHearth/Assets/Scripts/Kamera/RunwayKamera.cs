using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class RunwayKamera : MonoBehaviour
{
    private float turnAngle, tiltAngle;
    private string inputX = "Horizontal";
    private string inputY = "Vertical";
    private Transform cameraTransform;

    [SerializeField] [Range(5,15)] private readonly float mouseSensitivity = 5;
    [SerializeField] [Range(1, 5)] private float restingDistance = 2.5f;

    private void Start()
    {
        cameraTransform = transform.GetComponentInChildren<Camera>().transform;
    }

    private void Update()
    {
        SetHeight();

        if (Input.GetMouseButton(0) || Input.GetButton("Horizontal") || Input.GetButton("Vertical"))
            Rotate();

        Move();
    }

    private void Move()
    {
        Vector3 spherecastSmjer = (cameraTransform.position - transform.position).normalized;

        if (Physics.SphereCast(transform.position, 0.35f, spherecastSmjer, out RaycastHit hit, restingDistance, LayerMask.GetMask("Default")))
        {
            cameraTransform.position = Vector3.Lerp(cameraTransform.position, transform.position + spherecastSmjer * hit.distance, 0.2f);
        }
        else
        {
            cameraTransform.position = Vector3.Lerp(cameraTransform.position, transform.position + spherecastSmjer * restingDistance, 0.2f);
        }

        float misScroll = Input.mouseScrollDelta.y;
        if (misScroll != 0)
        {
            restingDistance -= misScroll * Time.deltaTime * 10;
            restingDistance = Mathf.Clamp(restingDistance, 1, 5);
        }
    }

    private void Rotate()
    {
        if (EventSystem.current.IsPointerOverGameObject())
            return;

        if (Input.GetMouseButton(0))
        {
            inputX = "Mouse X";
            inputY = "Mouse Y";
        }
        else if (Input.GetButton("Vertical") || Input.GetButton("Horizontal"))
        {
            inputX = "Horizontal";
            inputY = "Vertical";
        }

        float x = Input.GetAxis(inputX);
        float y = Input.GetAxis(inputY);

        turnAngle -= x * mouseSensitivity;

        tiltAngle += y * mouseSensitivity;
        tiltAngle = Mathf.Clamp(tiltAngle, -45, 45);

        transform.rotation = Quaternion.Euler(tiltAngle, turnAngle, 0);
    }

    private void SetHeight()
    {
        if (Input.GetKey("q"))
        {
            Vector3 pos = transform.position + Vector3.down;
            pos.y = Mathf.Clamp(pos.y, 1, 2);
            transform.position = Vector3.Lerp(transform.position, pos, Time.deltaTime);
        }
        if (Input.GetKey("e"))
        {
            Vector3 pos = transform.position + Vector3.up;
            pos.y = Mathf.Clamp(pos.y, 1, 2);
            transform.position = Vector3.Lerp(transform.position, pos, Time.deltaTime);
        }
    }
}
