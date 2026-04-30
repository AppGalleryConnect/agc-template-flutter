import { formBindingData, FormExtensionAbility, formInfo } from '@kit.FormKit';
import { UtilLog } from '@hw-agconnect/util-log';
import { Want } from '@kit.AbilityKit';
import { FormUtils } from '../common/FormUtils';
import { FormCardData } from '../common/Types';

const TAG: string = '[EntryFormAbility]';

export default class EntryFormAbility extends FormExtensionAbility {
  private formData: FormCardData = {
    data: FormUtils.getDefaultFormData(),
  };

  onAddForm(want: Want) {
    if (!FormUtils.isSubscribed) {
      FormUtils.subscribeFormId(this.context, TAG);
    }

    let formId: string = want.parameters?.[formInfo.FormParam.IDENTITY_KEY] as string;
    UtilLog.info(TAG, `onAddForm formId: ${formId}`);
    if (formId) {
      FormUtils.addFormId(formId, this.context);
      FormUtils.publishFormId(formId, false);
    }

    return formBindingData.createFormBindingData(this.formData);
  }

  onRemoveForm(formId: string) {
    UtilLog.info(TAG, `onRemoveForm, formId = ${formId}`);
    FormUtils.delFormId(formId, this.context);
    FormUtils.publishFormId(formId, true);
  }

  onAcquireFormState(want: Want) {
    return formInfo.FormState.READY;
  }
}