using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class AnotherTest : MonoBehaviour {

	int n_letters = 5;
	int n_used_letters = 2;


	void OnMouseEnter() {

		int max_used_letters = 64 + n_used_letters;

		ErzeugeAlleWorte ("", n_letters, max_used_letters);
	}
		

	private static void ErzeugeAlleWorte (String strBegin, int length, int max_letters)
	{
		if (length <= 0) {
			Debug.Log(strBegin);
			return;
		}

		for(int i = 65; i <= max_letters; i++) {
			ErzeugeAlleWorte (strBegin + Convert.ToChar(i), length - 1, max_letters);
		}
	}
}










// SCInterface.Instance.SetNodeValue (100, "delay", 0.6);


