package delight.nashornsandbox.internal

import delight.nashornsandbox.NashornSandbox
import java.util.HashSet
import java.util.Set
import javax.script.Invocable
import javax.script.ScriptEngine
import jdk.nashorn.api.scripting.NashornScriptEngineFactory

class NashornSandboxImpl implements NashornSandbox {

	val Set<String> allowedClasses

	var ScriptEngine scriptEngine
	var Integer maxCPUTimeInMs = 0

	def void assertScriptEngine() {
		if (scriptEngine != null) {
			return
		}

		/*
		 * If eclipse shows an error here, see http://stackoverflow.com/a/10642163/270662
		 */
		val NashornScriptEngineFactory factory = new NashornScriptEngineFactory();

		scriptEngine = factory.getScriptEngine(new SandboxClassFilter(allowedClasses));
		
		scriptEngine.eval(BeautifyJs.CODE)
	}

	override Object eval(String js) {
		assertScriptEngine

		if (maxCPUTimeInMs == 0) {
			return scriptEngine.eval(js)
		}
		
		val monitorThread = new MonitorThread(maxCPUTimeInMs*1000, Thread.currentThread, [
			Thread.currentThread.interrupt
		])
		
		
		
		val Invocable invocable = scriptEngine.eval('jsbeautifier.beautify;') as Invocable

		val Object result = invocable.invokeFunction("fun1", "Peter Parker");
		
		scriptEngine.eval(js)

		
		val res = scriptEngine.eval(js)
		
		monitorThread.stopMonitor
		
		res
		
		
	}

	override void allow(Class<?> clazz) {
		allowedClasses.add(clazz.name)
		scriptEngine = null
	}

	new() {
		this.allowedClasses = new HashSet()
	}

}