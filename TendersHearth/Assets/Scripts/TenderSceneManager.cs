using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class TenderSceneManager : MonoBehaviour
{
    [Header("Tender")]
    public SkinnedMeshRenderer tenderBody;
    public SkinnedMeshRenderer tenderInner;
    public SkinnedMeshRenderer poncho;

    [Header("Materijali")]
    public Material[] materijali;

    [Header("UI - scrollbar")]
    public Canvas canvas;

    [Header("UI - scrollbar")]
    public TextMeshProUGUI scrollbarLabel;
    public Image scrollBar;
    public Image scrollHandle;

    [Header("UI - rotation toggle")]
    public TextMeshProUGUI rotationLabel;
    public Image rotationToggle;
    public Image rotationCheckmark;

    [Header("Osvijetljenje")]
    public Light pulseOganj;
    public Light pulseTender;
    public Scrollbar pulseScrollbar;
    public Transform dirLight;

    [Header("Rotator")]
    public Transform lightRotator;

    private void Start()
    {
        rotationToggle.enabled = false;
        rotationCheckmark.enabled = false;
        rotationLabel.color = new Color(rotationLabel.color.r, rotationLabel.color.g, rotationLabel.color.b, 0.1f);
        rotationToggle.color = new Color(rotationToggle.color.r, rotationToggle.color.g, rotationToggle.color.b, 0.1f);
        rotationCheckmark.color = new Color(rotationToggle.color.r, rotationToggle.color.g, rotationToggle.color.b, 0.1f);

        pulseScrollbar.enabled = false;
        scrollbarLabel.color = new Color(scrollBar.color.r, scrollBar.color.g, scrollBar.color.b, 0.1f);
        scrollBar.color = new Color(scrollBar.color.r, scrollBar.color.g, scrollBar.color.b, 0.1f);
        scrollHandle.color = new Color(scrollBar.color.r, scrollBar.color.g, scrollBar.color.b, 0.1f);
    }

    private void Update()
    {
        if (Input.GetKeyDown("escape"))
        {
            if (canvas.enabled)
                canvas.enabled = false;
            else
                canvas.enabled = true;
        }
    }

    public void ToggleCameraLookIKScript()
    {
        GledajKameruIK.enableIK = !GledajKameruIK.enableIK;
    }

    public void TogglePulseLight()
    {
        bool status = pulseOganj.GetComponent<LightPulse>().enabled;
        if (status)
        {
            pulseOganj.GetComponent<LightPulse>().enabled = false;
            pulseTender.GetComponent<LightPulse>().enabled = false;
            pulseScrollbar.enabled = true;
            scrollbarLabel.color = new Color(scrollbarLabel.color.r, scrollbarLabel.color.g, scrollbarLabel.color.b, 1);
            scrollBar.color = new Color(scrollBar.color.r, scrollBar.color.g, scrollBar.color.b, 1);
            scrollHandle.color = new Color(scrollHandle.color.r, scrollHandle.color.g, scrollHandle.color.b, 1);
        }
        else
        {
            pulseScrollbar.enabled = false;
            scrollbarLabel.color = new Color(scrollbarLabel.color.r, scrollbarLabel.color.g, scrollbarLabel.color.b, 0.1f);
            scrollBar.color = new Color(scrollBar.color.r, scrollBar.color.g, scrollBar.color.b, 0.1f);
            scrollHandle.color = new Color(scrollBar.color.r, scrollBar.color.g, scrollBar.color.b, 0.1f);
            pulseOganj.GetComponent<LightPulse>().enabled = true;
            pulseTender.GetComponent<LightPulse>().enabled = true;
        }
    }

    public void UpdatePulseLight(float value)
    {
        float lightValue = 1 + value * 5;
        pulseOganj.intensity = lightValue;
        pulseTender.intensity = lightValue;
    }

    public void ToggleLightRotator(bool status)
    {
        lightRotator.gameObject.SetActive(status);
        if (status)
        {
            rotationToggle.enabled = true;
            rotationCheckmark.enabled = true;
            rotationLabel.color = new Color(rotationLabel.color.r, rotationLabel.color.g, rotationLabel.color.b, 1);
            rotationToggle.color = new Color(rotationToggle.color.r, rotationToggle.color.g, rotationToggle.color.b, 1);
            rotationCheckmark.color = new Color(rotationToggle.color.r, rotationToggle.color.g, rotationToggle.color.b, 1);
        }
        else
        {
            rotationToggle.enabled = false;
            rotationCheckmark.enabled = false;
            rotationLabel.color = new Color(rotationLabel.color.r, rotationLabel.color.g, rotationLabel.color.b, 0.1f);
            rotationToggle.color = new Color(rotationToggle.color.r, rotationToggle.color.g, rotationToggle.color.b, 0.1f);
            rotationCheckmark.color = new Color(rotationToggle.color.r, rotationToggle.color.g, rotationToggle.color.b, 0.1f);
        }
    }

    public void ToggleLightRotation(bool status)
    {
        lightRotator.GetComponent<SimpleRotation>().enabled = status;
    }

    public void TogglePlast(bool status)
    {
        poncho.enabled = status;
    }

    public void ChangeMaterialTo(int index)
    {
        if (materijali[index] != null)
        {
            tenderBody.material = materijali[index];
            poncho.material = materijali[index];

            if (index > 1)
            {
                tenderInner.enabled = false;
                if (index == 5)
                    dirLight.gameObject.SetActive(true);
            }
            else
            {
                tenderInner.enabled = true;
            }

            if (index != 5 && dirLight.gameObject.activeSelf)
                dirLight.gameObject.SetActive(false);
        }
        else
        {
            Debug.LogError("Materijali nisu učitani! (TenderSceneManager.ChangeMaterialTo)");
        }
    }

    public void QuitApplication()
    {
        Application.Quit();
    }
}
