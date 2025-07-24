using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[ExecuteAlways]
public class PostProcess : MonoBehaviour
{

    public Material gotas;
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, gotas);
    }
}
