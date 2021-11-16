# Overview

Got frustrated trying to get a proper kubectl pod yaml to work, so went this route instead.

Just one file here, just to create a bunch of namespaces that will be required later.

Jenkins is explicitly left out as any attempt to revert kapp deploys with kapp deletes get wonky with it being tracked there.
