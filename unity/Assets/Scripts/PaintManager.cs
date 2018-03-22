﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.iOS;

public class PaintManager : MonoBehaviour
{
	
	public GameObject gameObject;

	private bool paintingOn;
	private Color paintColor;
	private Vector3 previousPosition;
	private List<GameObject> gameObjectList;

	
	
//	public GameObject cubeObj;
//	private Vector3 previousPosition;
	
	void OnEnable() {
		UnityARSessionNativeInterface.ARFrameUpdatedEvent += ARFrameUpdated;
	}

	void OnDestroy() {
		UnityARSessionNativeInterface.ARFrameUpdatedEvent -= ARFrameUpdated;
	}

	
	// Use this for initialization
	void Start ()
	{
		paintingOn = false;
		paintColor = Color.green;
		
	}
	
	// Update is called once per frame
	void Update () {
	}
	
	public void TogglePaint()
	{
		paintingOn = !paintingOn;
	}

	public void RandomizeColor()
	{
		paintColor = Random.ColorHSV();
		
	}

	public void Reset()
	{
		foreach (GameObject p in gameObjectList)
		{
			Destroy(p);
		}

		gameObjectList= new List<GameObject>();

	}

	private void SaveGameObject()
	{
		gameObjectList.Add(gameObject);
	}
	
	private void ARFrameUpdated(UnityARCamera arCamera) {
		Vector3 paintPosition = GetCameraPosition(arCamera) + (Camera.main.transform.forward * 0.3f);
		if (paintingOn && Vector3.Distance(paintPosition, previousPosition) > 0.03f)
		{
//			Instantiate(gameObject, paintPosition, transform.rotation);
			GameObject go = PhotonNetwork.Instantiate(this.gameObject.name, new Vector3(0, 0, 0), Quaternion.identity, 0);
//			Vector3 temp = paintPosition;
//			temp[1] += 2.0f;
//			temp[0] += 1.0f;
//			temp[2] += 1.0f;
			go.transform.position = paintPosition;
			go.transform.rotation = transform.rotation;
			previousPosition = paintPosition;
		}
	}
	
	private Vector3 GetCameraPosition(UnityARCamera cam) {
		Matrix4x4 matrix = new Matrix4x4 ();
		matrix.SetColumn (3, cam.worldTransform.column3);
		return UnityARMatrixOps.GetPosition (matrix);
	}
}
