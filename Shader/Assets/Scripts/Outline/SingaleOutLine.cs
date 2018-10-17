using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[ExecuteInEditMode]
public class SingaleOutLine : MonoBehaviour {
    [SerializeField]
    Material material;
    // Use this for initialization
    void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        Graphics.DrawMesh(GetComponent<Mesh>(), Vector3.zero, Quaternion.identity, material, 0);
    }

  
}
