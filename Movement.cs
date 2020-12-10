using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Movement : MonoBehaviour
{
    new Rigidbody rigidbody;
    // Start is called before the first frame update
    void Start()
    {
        rigidbody = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetKey("w"))
            rigidbody.AddForce(0,10,0);
        if(Input.GetKey("a"))
            rigidbody.AddForce(-10,0,0);

        if(Input.GetKey("d"))
            rigidbody.AddForce(10,0,0);
            if(Input.GetKey("s"))
            rigidbody.AddForce(0,-10,0);

           
        
    }
}
