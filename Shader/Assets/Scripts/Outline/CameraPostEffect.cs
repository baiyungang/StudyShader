using UnityEngine;
[ExecuteInEditMode]
public class CameraPostEffect : MonoBehaviour
{
    [SerializeField]
    private Material mat;
    // Use this for initialization
    void Start()
    {
       
        GetCamera().depthTextureMode = DepthTextureMode.DepthNormals;
    }
    private Camera myCamera;
    public Camera GetCamera()
    {
        if (myCamera == null)
        {
            myCamera = Camera.main; 


        }
        return myCamera;
    }
    // Update is called once per frame
    void Update()
    {

    }
    [ImageEffectOpaque]
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (mat != null)
            Graphics.Blit(source, destination, mat);
        else
            Graphics.Blit(source, destination);
    }
}
