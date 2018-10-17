using UnityEngine;
[ExecuteInEditMode]
public class TestDepth : MonoBehaviour {
    [SerializeField]
    private Material mat;
    // Use this for initialization
    [SerializeField]
    bool isDepthOfField;
    [SerializeField]
    Material blureMat;
  
    void Start () {
        GetCamera().depthTextureMode = DepthTextureMode.DepthNormals;
    }
    private Camera myCamera;
    public Camera GetCamera()
    {
            if (myCamera == null)
            {
                myCamera = GetComponent<Camera>();
            }
            return myCamera;
    }
    // Update is called once per frame
    void Update () {
		
	}

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if(isDepthOfField)
        {
            RenderTexture blure = RenderTexture.GetTemporary(source.width, source.height);
            Graphics.Blit(source, blure, blureMat);
            mat.SetTexture("_BlureTex",blure);
            Graphics.Blit(source, destination, mat);

        }
        else
        {
            if(mat != null)
            {
                Graphics.Blit(source, destination, mat);
            }
            else
            {
                Graphics.Blit(source, destination);
            }
        }
    }
}
