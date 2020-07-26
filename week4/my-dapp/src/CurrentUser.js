import React, {useState, useEffect} from "react"
import * as fcl from "@onflow/fcl"


const SignInButton = () => {
  const [user, setUser] = useState(null)

  useEffect(() => fcl.currentUser().subscribe(setUser), [])

  if (user == null) return null
  if (user.loggedIn) return null

  return <button onClick={fcl.authenticate}>Sign In/Up</button>
}

const UserProfile = () => {
  const [user, setUser] = useState(null)

  useEffect(() => fcl.currentUser().subscribe(setUser), [])

  if (user == null) return null

  if (!user.loggedIn) return null
  return (
    <>
      {user.identity.avatar && <img src={user.identity.avatar} />}
      <div>{user.identity.name || "Anonymous"}</div>
      <button onClick={fcl.unauthenticate}>Sign Out</button>
    </>
  )
}

const CurrentUser = () => {
  return (
    <div>
      <SignInButton />
      <UserProfile />
    </div>
  )
}

export default CurrentUser