using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class ApplyEffect : MonoBehaviour
{
	Queue<Vector3> _recentPositions = new Queue<Vector3>();
	
	public int _frameLag = 0;
	new Rigidbody rigidbody;
	float lastVelocity;
	float acceleration;
	public float accRatio;


	Material smearMat;
    void Start()
    {
        smearMat = GetComponent<Renderer>().material;
		rigidbody = GetComponent<Rigidbody>();
    }

	void FixedUpdate()
	{
		acceleration = rigidbody.velocity.magnitude - lastVelocity;
		lastVelocity = rigidbody.velocity.magnitude;
		if(_recentPositions.Count > _frameLag)
			smearMat.SetVector("_PrevPosition", _recentPositions.Dequeue());

		smearMat.SetVector("_Position", transform.position);
		_recentPositions.Enqueue(transform.position);
		
		smearMat.SetFloat("_Impact", acceleration*accRatio);
	}
	void LateUpdate()
	{
		
		
	}
	
}
