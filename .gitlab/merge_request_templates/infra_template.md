## Infrastructure Submissions:
-------------------------------------
* [YES/NO] Have you added an explanation of what your changes do and why you'd like us to include them?
* [YES/NO] I have updated the documentation accordingly.
* [YES/NO/NA] I have added tests to cover my changes.
* [YES/NO/NA] All new and existing tests passed.
* [YES/NO/NA] I have formatted the terraform code.  _(`terraform fmt -recursive && go fmt ./...`)_

## Current Behavior or Linked Issues
-------------------------------------
<!-- Please describe the current behavior that you are modifying, or link to a relevant issue. -->


## Does this introduce a breaking change?
-------------------------------------
- [YES/NO]

<!-- If this introduces a breaking change, please describe the impact and migration path for existing applications below. -->

## MR Guildelines
- [ ] Paste TF Plan for the MR. 
- [ ] Pre-Merge pipeline should be run before merging. (Azure team)
- [ ] Does the module exists for new resource. 
- [ ] Is there a new variable added in the MR. (Don’t use library variables and use locals) 

## Other information
-------------------------------------
<!-- Any other information that is important to this PR such as screenshots of how the component looks before and after the change. -->
