using UnityEngine;

public class UFO : MonoBehaviour
{
    [Header("Velocidad de rotaci�n")]
    public Vector3 velocidadRotacion = new Vector3(0f, 50f, 0f); // Rota sobre Y por defecto

    void Update()
    {
        transform.Rotate(velocidadRotacion * Time.deltaTime);
    }
}
