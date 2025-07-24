using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LightningEffect : MonoBehaviour
{
    [Header("Luz y valores")]
    public Light luzDireccional;
    public float intensidadRelampago = 4f;
    public float intensidadNormal = 1f;

    [Header("Tiempos")]
    public float intervaloRelampago = 10f;
    public float duracionTitileo = 0.3f;
    public float duracionApagado = 0.2f;

    private void Start()
    {
        if (luzDireccional == null)
            luzDireccional = GetComponent<Light>();

        luzDireccional.intensity = intensidadNormal;
        InvokeRepeating(nameof(DispararRelampago), intervaloRelampago, intervaloRelampago);
    }

    void DispararRelampago()
    {
        StartCoroutine(EfectoRelampago());
    }

    IEnumerator EfectoRelampago()
    {
        luzDireccional.intensity = intensidadRelampago;
        yield return new WaitForSeconds(Random.Range(0.05f, 0.1f));

        luzDireccional.intensity = intensidadNormal;
        yield return new WaitForSeconds(Random.Range(0.05f, 0.1f));

        luzDireccional.intensity = intensidadRelampago;
        yield return new WaitForSeconds(duracionTitileo);

        StartCoroutine(TransicionIntensidad(intensidadRelampago, intensidadNormal, duracionApagado));
    }

    IEnumerator TransicionIntensidad(float desde, float hasta, float duracion)
    {
        float tiempo = 0f;

        while (tiempo < duracion)
        {
            tiempo += Time.deltaTime;
            float t = tiempo / duracion;
            luzDireccional.intensity = Mathf.Lerp(desde, hasta, t);
            yield return null;
        }

        luzDireccional.intensity = hasta;
    }
}
