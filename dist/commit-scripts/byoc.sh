# #!/bin/sh

FILE=$SCAN_RESULT_DIR/trivyScanResult
if [ -f "$FILE" ]; then
    sed -i '/$CONTAINER_REGISTRY/d' $FILE
fi
rm -rf $GITOPS_CLONE/$SCAN_RESULT_DIR
mv $SCAN_RESULT_DIR $GITOPS_CLONE
cd $GITOPS_CLONE
echo "WORKSPACE=$(basename "$PWD")" >> $GITHUB_ENV
git config user.name $COMMIT_USER
git config user.email $COMMIT_EMAIL
git fetch --unshallow
echo "Runner ID: ${{ github.run_id }}" >> info.txt
echo "Component ID: $APP_ID" >> info.txt
echo "Org ID: $CHOREO_ORG_ID" >> info.txt
echo "ENV ID: ${{ github.event.inputs.envId }}" >> info.txt
git add .
git commit -m $NEW_SHA
git push -f origin main
echo "NEW_GITOPS_SHA=$(git rev-parse HEAD)" >> $GITHUB_ENV