# How to Version

Once you're happy with develop branch and you're ready to release a new version, `git pull` and open in Xcode.

## Summary

1. Increment version number in Xcode
2. Reset build number back to 1
3. In Xcode, Product > Archive
4. Upload the new archive to App Store Connect
5. Login to App Store Connect
6. Prepare the new version for Test Flight
7. *Optional*. If tweaks are required in code, record changes in a new branch, then repeat steps 3 - 6
8. Release the new version in Test Flight
9. Commit code changes, push, then Pull Request to Develop
10. In GitHub, [^create a tag] with the following [^name format] : `v0.0.1`

## References

[Semantic Versioning](https://semver.org)
[Tutorial: Test Flight](https://www.raywenderlich.com/5352-testflight-tutorial-ios-beta-testing)

[^create a tag]: Release to App Store Connect, then tag in GitHub. Make tagging the last step, because you might need to make tweaks to the code in order for Apple to accept/approve it.

[^name format]: Don't put letters in your version field. Only numbers and dots. Xcode will accept letters in the version field, however Apple will reject your app as soon as you upload it to App Connect.
