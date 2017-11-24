using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq.Expressions;
using System;
public class MemberInfoGetting : MonoBehaviour {

	public static string GetMemberName<T>(Expression<Func<T>> memberExpression)
	{
		MemberExpression expressionBody = (MemberExpression)memberExpression.Body;
		return expressionBody.Member.Name;
	}

}
