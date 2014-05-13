package github.giuliolunati.rebol3sl4a;

import android.content.Context;

import com.googlecode.android_scripting.interpreter.InterpreterConstants;
import com.googlecode.android_scripting.interpreter.InterpreterUtils;
import com.googlecode.android_scripting.interpreter.InterpreterDescriptor;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Rebol3Descriptor implements InterpreterDescriptor {

  /* Properties */

  @Override
  public String getName() {
    return "rebol3";
  }

  @Override
  public String getNiceName() {
    return "Rebol 3";
  }

  @Override
  public String getExtension() {
    return ".reb";
  }

  @Override
  public File getBinary(Context context) {
    return new File(getHome(context), "bin/rebol3");
  }

  @Override
  public String getInteractiveCommand(Context context) {
    return "-q";
  }

  @Override
  public String getScriptCommand(Context context) {
    return "%s";
  }

  @Override
  public boolean hasInteractiveMode() {
    return true;
  }

  /* Directories */

  private String getHome(Context context) {
    File file = InterpreterUtils.getInterpreterRoot(context);
    return file.getAbsolutePath();
  }

  private String getExtrasRoot() {
    return InterpreterConstants.SDCARD_ROOT + getClass().getPackage().getName()
        + InterpreterConstants.INTERPRETER_EXTRAS_ROOT;
  }

  public String getExtras() {
    File file = new File(getExtrasRoot(), getName());
    return file.getAbsolutePath();
  }

  private String getTemp() {
    File tmp = new File(getExtrasRoot(), getName() + "/tmp");
    if (!tmp.isDirectory()) {
      tmp.mkdir();
    }
    return tmp.getAbsolutePath();
  }

  /* Arguments*/

  @Override
  public List<String> getArguments(Context context) {
    return new ArrayList<String>();
  }

  /* Environment */

  @Override
  public Map<String, String> getEnvironmentVariables(Context context) {
    Map<String, String> values = new HashMap<String, String>();
    values.put("HOME", getHome(context));
    return values;
  }

  /* Downloads */

  @Override
  public int getVersion() {
    return 0;
  }

  public static final String BASE_INSTALL_URL = "http://giuliolunati.altervista.org/Rebol3/";

  @Override
  public boolean hasInterpreterArchive() {
    return false;
  }

  @Override
  public String getInterpreterArchiveName() {
    return String.format("%s_r%s.zip", getName(), getVersion());
  }

  @Override
  public String getInterpreterArchiveUrl() {
    return BASE_INSTALL_URL + getInterpreterArchiveName();
  }

  @Override
  public boolean hasExtrasArchive() {
    return false;
  }

  @Override
  public String getExtrasArchiveName() {
    return null;
  }

  @Override
  public String getExtrasArchiveUrl() {
    return null;
  }

  @Override
  public boolean hasScriptsArchive() {
    return false;
  }

  @Override
  public String getScriptsArchiveName() {
    return String.format("%s_scripts_r%s.zip", getName(), getVersion());
  }

  @Override
  public String getScriptsArchiveUrl() {
    return BASE_INSTALL_URL + getScriptsArchiveName();
  }
}
